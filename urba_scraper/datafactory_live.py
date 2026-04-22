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


def parse_date(raw: str | None) -> str | None:
    if not raw:
        return None
    for fmt in ("%d/%m/%Y %H:%M", "%Y-%m-%dT%H:%M:%S", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M"):
        try:
            dt = datetime.strptime(raw.strip(), fmt)
            return dt.strftime("%Y-%m-%dT%H:%M:%S-03:00")
        except ValueError:
            continue
    return raw


def parse_match(tag, channel_id: str | None, round_name: str) -> dict | None:
    """
    Parsea un div.mc-matchContainer.
    Intenta obtener datos del livescore JSON primero; si no, cae en HTML.
    """
    # ── Datos del HTML ────────────────────────────────────────────────────────
    # Selectores comunes de datafactory — ajustar si es necesario
    home_name = text_or_none(tag,
        ".mc-local .mc-teamName", ".mc-home .mc-teamName",
        ".mc-local .name",        ".local .mc-teamName",
        ".mc-teamName:first-of-type",
    )
    away_name = text_or_none(tag,
        ".mc-visit .mc-teamName", ".mc-away .mc-teamName",
        ".mc-visit .name",        ".visit .mc-teamName",
    )
    date_str = text_or_none(tag, ".mc-date", ".mc-datetime", ".matchDate", "time")
    time_str = text_or_none(tag, ".mc-time", ".matchTime")
    if date_str and time_str and " " not in date_str:
        date_str = f"{date_str} {time_str}"
    date_iso = parse_date(date_str)

    # Estado inicial desde clases CSS del contenedor
    classes = " ".join(tag.get("class", []))
    raw_status_html = "notStarted"
    if "inProgress" in classes or "status-inProgress" in classes:
        raw_status_html = "inProgress"
    elif "end" in classes or "status-end" in classes or "finished" in classes:
        raw_status_html = "end"

    home_score: int | None = None
    away_score: int | None = None
    status_short = "NS"

    # ── Livescore JSON (más confiable para partidos en curso) ─────────────────
    if channel_id and raw_status_html in ("inProgress",):
        live = fetch_livescore(channel_id)
        if live:
            status_short = map_status(live)
            score = live.get("score") or {}
            home_score = int_or_none(score.get("local") or live.get("localScore"))
            away_score = int_or_none(score.get("visit") or live.get("visitScore"))
            # Nombres desde livescore si no los encontramos en el HTML
            if not home_name:
                home_name = live.get("localTeam", {}).get("name") or live.get("local_team")
            if not away_name:
                away_name = live.get("visitTeam", {}).get("name") or live.get("visit_team")
    elif raw_status_html == "end":
        status_short = "FT"
        home_score = int_or_none(text_or_none(tag,
            ".mc-score-local", ".mc-result-local", ".local .score", ".home .score"))
        away_score = int_or_none(text_or_none(tag,
            ".mc-score-visit", ".mc-result-visit", ".visit .score", ".away .score"))

    if not home_name or not away_name:
        log.debug(f"Partido sin nombres, saltando. channel={channel_id}")
        return None

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
        log.info(f"Partidos encontrados en sección Top 14: {len(match_tags)}")

        matches = []
        for tag in match_tags:
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
