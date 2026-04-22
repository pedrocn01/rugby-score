"""
Scraper en vivo para el URBA Top 14 División Superior.
Extrae resultados de datafactory, los convierte al formato de la app
y los sube al Worker de Cloudflare via PUT /urba-live.

Corre cada minuto los sábados via GitHub Actions (ver .github/workflows/urba_live.yml).

Variables de entorno requeridas:
  WORKER_URL        → URL del Worker (ej: https://rugby-proxy.xxx.workers.dev)
  LIVE_SECRET_TOKEN → token secreto configurado con wrangler secret put LIVE_SECRET_TOKEN
"""

import os
import re
import json
import logging
import requests
from datetime import datetime, timezone
from bs4 import BeautifulSoup

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
log = logging.getLogger(__name__)

FIXTURE_URL   = "https://espn.datafactory.la/html/v3/htmlCenter/data/deportes/rugby/urba/pages/es/fixture.html"
LIVESCORE_URL = "https://espn.datafactory.la/html/v3/htmlCenter/data/deportes/rugby/urba/events/es/{channel_id}/livescore.json"

WORKER_URL        = os.environ["WORKER_URL"].rstrip("/")
LIVE_SECRET_TOKEN = os.environ["LIVE_SECRET_TOKEN"].strip()  # .strip() evita errores por espacios/newlines

HEADERS = {"User-Agent": "Mozilla/5.0 (rugby-score-app/1.0)"}

# Valor del atributo data-league que identifica el Top 14 División Superior.
# Ajustar si datafactory cambia el nombre del torneo.
TOP14_LEAGUE_ATTR = "URBA - Division Superior - Top 14"


def fetch_fixture_html() -> str:
    resp = requests.get(FIXTURE_URL, headers=HEADERS, timeout=15)
    resp.raise_for_status()
    return resp.text


def fetch_livescore(channel_id: str) -> dict | None:
    url = LIVESCORE_URL.format(channel_id=channel_id)
    try:
        resp = requests.get(url, headers=HEADERS, timeout=10)
        if resp.status_code == 404:
            return None
        resp.raise_for_status()
        return resp.json()
    except Exception as e:
        log.warning(f"No se pudo obtener livescore para channel {channel_id}: {e}")
        return None


def extract_channel_id(data_channel: str) -> str | None:
    """
    data-channel tiene formato 'deportes.rugby.urba.XXXXXX'.
    Extrae el ID numérico al final.
    """
    if not data_channel:
        return None
    parts = data_channel.strip().split(".")
    return parts[-1] if parts else None


def map_status(livescore: dict) -> str:
    """Convierte el estado del livescore JSON al código que usa la app Flutter."""
    status = str(livescore.get("status") or livescore.get("matchStatus") or "").lower()
    period = str(livescore.get("period") or livescore.get("time_name") or "").lower()

    if any(x in status for x in ("inprogress", "in_progress", "live", "playing")):
        if any(x in period for x in ("half", "ht", "descanso", "medio")):
            return "HT"
        if any(x in period for x in ("second", "2h", "segundo")):
            return "2H"
        return "1H"
    if any(x in status for x in ("end", "finished", "final", "completed")):
        return "FT"
    return "NS"


def text_or_none(tag, *selectors) -> str | None:
    for sel in selectors:
        found = tag.select_one(sel)
        if found:
            t = found.get_text(strip=True)
            if t:
                return t
    return None


def int_or_none(val) -> int | None:
    try:
        return int(val)
    except (TypeError, ValueError):
        return None


def parse_date_originaldate(raw: str | None) -> str | None:
    """Convierte data-originaldate='2026/03/14 15:30' a ISO 8601 con zona Argentina."""
    if not raw:
        return None
    for fmt in ("%Y/%m/%d %H:%M", "%d/%m/%Y %H:%M", "%Y-%m-%dT%H:%M:%S", "%Y-%m-%d %H:%M"):
        try:
            dt = datetime.strptime(raw.strip(), fmt)
            return dt.strftime("%Y-%m-%dT%H:%M:%S-03:00")
        except ValueError:
            continue
    return raw


def parse_match(tag, channel_id: str | None, round_name: str) -> dict | None:
    """Parsea un div.mc-matchContainer con la estructura real de datafactory."""

    # ── Nombres de equipo ─────────────────────────────────────────────────────
    # Estructura real: <div class="local ..."><div class="equipo ...">Nombre</div>
    home_name = text_or_none(tag, ".local .equipo")
    away_name = text_or_none(tag, ".visitante .equipo")

    if not home_name or not away_name:
        log.debug(f"Partido sin nombres, saltando. channel={channel_id}")
        return None

    # ── Fecha desde atributo data-originaldate ────────────────────────────────
    original_date = tag.get("data-originaldate", "")  # "2026/03/14 15:30"
    date_iso  = parse_date_originaldate(original_date)
    timestamp = 0
    if date_iso:
        try:
            timestamp = int(datetime.fromisoformat(date_iso).timestamp())
        except ValueError:
            pass

    # ── Estado desde clases CSS del container ─────────────────────────────────
    classes = " ".join(tag.get("class", []))
    if "status-inProgress" in classes:
        raw_status = "inProgress"
    elif "status-finished" in classes or "status-end" in classes:
        raw_status = "finished"
    else:
        raw_status = "notStarted"

    home_score: int | None = None
    away_score: int | None = None
    status_short = "NS"

    if raw_status == "inProgress" and channel_id:
        # Pedir livescore para obtener marcador y periodo exactos
        live = fetch_livescore(channel_id)
        if live:
            status_short = map_status(live)
            score = live.get("score") or {}
            home_score = int_or_none(score.get("local") or live.get("localScore"))
            away_score = int_or_none(score.get("visit") or live.get("visitScore"))
        else:
            # Sin livescore disponible: leer marcador del HTML
            status_short = "1H"
            home_score = int_or_none(text_or_none(tag, ".local .resultado"))
            away_score = int_or_none(text_or_none(tag, ".visitante .resultado"))

    elif raw_status == "finished":
        status_short = "FT"
        home_score = int_or_none(text_or_none(tag, ".local .resultado"))
        away_score = int_or_none(text_or_none(tag, ".visitante .resultado"))

    timestamp = 0
    if date_iso:
        try:
            timestamp = int(datetime.fromisoformat(date_iso).timestamp())
        except ValueError:
            pass

    return {
        "date":      date_iso or "",
        "timestamp": timestamp,
        "week":      round_name,
        "status":    {"short": status_short, "long": status_short},
        "scores": {
            "home": home_score if status_short != "NS" else None,
            "away": away_score if status_short != "NS" else None,
        },
        "teams": {
            "home": {"name": home_name, "logo": None},
            "away": {"name": away_name, "logo": None},
        },
    }


def main():
    log.info("Fetching fixture HTML...")
    html = fetch_fixture_html()
    soup = BeautifulSoup(html, "html.parser")

    # ── Buscar la sección del Top 14 División Superior ────────────────────────
    # El div tiene data-league="URBA - Division Superior - Top 14"
    top14_section = soup.find(attrs={"data-league": re.compile(r"Top 14", re.I)})

    if top14_section is None:
        # Fallback: buscar por texto exacto del atributo
        top14_section = soup.find(attrs={"data-league": TOP14_LEAGUE_ATTR})

    if top14_section is None:
        log.error(f"No se encontró sección con data-league que contenga 'Top 14'. "
                  f"Valores disponibles: "
                  f"{[t.get('data-league') for t in soup.find_all(attrs={'data-league': True})[:10]]}")
        # Publicar lista vacía para no sobreescribir con basura
        matches = []
    else:
        log.info(f"Sección encontrada: data-league='{top14_section.get('data-league')}'")

        # Detectar nombre de ronda (buscar un header cercano)
        round_tag = top14_section.find(["h3", "h4", ".mc-round", ".round-name", ".jornada"])
        round_name = round_tag.get_text(strip=True) if round_tag else "Fecha actual"

        # ── Partidos dentro de la sección ─────────────────────────────────────
        match_tags = top14_section.find_all("div", class_="mc-matchContainer")
        log.info(f"Partidos en sección Top 14 (total temporada): {len(match_tags)}")

        # Filtrar solo los partidos de hoy (Argentina UTC-3)
        today_arg = datetime.now(timezone.utc).strftime("%Y/%m/%d")  # "2026/04/19"
        today_tags = [
            t for t in match_tags
            if t.get("data-originaldate", "").startswith(today_arg)
        ]
        log.info(f"Partidos de hoy ({today_arg}): {len(today_tags)}")

        matches = []
        for tag in today_tags:
            channel_attr = tag.get("data-channel", "")
            channel_id   = extract_channel_id(channel_attr)
            parsed = parse_match(tag, channel_id, round_name)
            if parsed:
                matches.append(parsed)

    log.info(f"Partidos parseados: {len(matches)}")

    payload = {
        "matches":    matches,
        "updated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
    }

    # ── PUT al Worker ─────────────────────────────────────────────────────────
    put_url = f"{WORKER_URL}/urba-live"
    log.info(f"Subiendo datos a {put_url}...")
    resp = requests.put(
        put_url,
        headers={
            "Content-Type":   "application/json",
            "X-Secret-Token": LIVE_SECRET_TOKEN,
        },
        data=json.dumps(payload),
        timeout=10,
    )
    resp.raise_for_status()
    log.info(f"OK: {resp.json()}")


if __name__ == "__main__":
    main()
