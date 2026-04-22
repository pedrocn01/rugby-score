"""
Scraper en vivo para el URBA Top 14 División Superior.
Extrae resultados de datafactory, los convierte al formato de la app
y los sube al Worker de Cloudflare via PUT /urba-live.

Corre cada minuto los sábados via GitHub Actions (ver .github/workflows/urba_live.yml).

Variables de entorno requeridas:
  WORKER_URL        → URL del Worker (ej: https://rugby-proxy.xxx.workers.dev)
  LIVE_SECRET_TOKEN → token secreto configurado en wrangler secret put LIVE_SECRET_TOKEN
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
LIVE_SECRET_TOKEN = os.environ["LIVE_SECRET_TOKEN"]

HEADERS = {"User-Agent": "Mozilla/5.0 (rugby-score-app/1.0)"}

# Nombres de sección que identifican la División Superior del Top 14.
# Ajustar si datafactory usa otro texto.
TOP14_SECTION_KEYWORDS = ["top 14", "división superior", "division superior", "top14"]


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
        log.warning(f"No se pudo obtener livescore para {channel_id}: {e}")
        return None


def is_top14_section(tag) -> bool:
    """Detecta si un tag de sección corresponde al Top 14 División Superior."""
    text = tag.get_text(separator=" ").lower()
    return any(kw in text for kw in TOP14_SECTION_KEYWORDS)


def map_status(datafactory_status: str, period: str | None) -> str:
    """Convierte el estado de datafactory al código que usa la app."""
    s = datafactory_status.lower()
    if "inprogress" in s or "in_progress" in s or s == "inprogress":
        p = (period or "").lower()
        if "half" in p or "ht" in p or p == "2":
            return "HT"
        if "second" in p or p in ("2h", "st"):
            return "2H"
        return "1H"  # default: primer tiempo
    if "end" in s or "finished" in s or "final" in s:
        return "FT"
    return "NS"


def parse_match(match_tag) -> dict | None:
    """
    Extrae datos de un tag HTML de partido.

    datafactory usa una estructura aproximada:
      <div class="match status-inProgress" data-channel-id="12345">
        <span class="team-name local">SIC</span>
        <span class="score local">14</span>
        <span class="score visit">7</span>
        <span class="team-name visit">CASI</span>
        <span class="date">19/04/2026 14:00</span>
        <span class="round">Fecha 5</span>
      </div>

    Si la estructura real difiere, ajustar los selectores abajo.
    """
    classes = " ".join(match_tag.get("class", []))

    # channel_id: puede estar como data-channel-id o en un link href
    channel_id = match_tag.get("data-channel-id") or match_tag.get("data-id")
    if not channel_id:
        link = match_tag.find("a", href=re.compile(r"/events/es/(\d+)/"))
        if link:
            m = re.search(r"/events/es/(\d+)/", link["href"])
            channel_id = m.group(1) if m else None

    # Nombres de equipo — intentar varios selectores comunes
    home_name = _text(match_tag, [".team-name.local", ".home .team-name", ".local .name", ".team-local"])
    away_name = _text(match_tag, [".team-name.visit", ".away .team-name", ".visit .name", ".team-visit"])

    if not home_name or not away_name:
        log.debug(f"Partido sin nombres de equipo, saltando. HTML: {match_tag}")
        return None

    # Fecha
    date_str = _text(match_tag, [".date", ".match-date", "time"])
    date_iso  = _parse_date(date_str)

    # Ronda
    round_name = _text(match_tag, [".round", ".jornada", ".fecha"]) or "Fecha actual"

    # Estado
    raw_status = "notStarted"
    for cls in ["status-inProgress", "status-end", "status-notStarted"]:
        if cls in classes:
            raw_status = cls.replace("status-", "")
            break

    # Logos (si están disponibles como <img>)
    home_logo = _logo(match_tag, [".team-local img", ".home img"])
    away_logo = _logo(match_tag, [".team-visit img", ".away img"])

    # Datos en vivo (scores, periodo)
    home_score = None
    away_score = None
    live_period = None

    if "inProgress" in raw_status or "end" in raw_status:
        if channel_id:
            live = fetch_livescore(channel_id)
            if live:
                home_score, away_score, live_period = _extract_scores(live)
        # fallback: intentar leer scores del propio HTML
        if home_score is None:
            home_score = _int(_text(match_tag, [".score.local", ".score-local", ".home .score"]))
            away_score = _int(_text(match_tag, [".score.visit", ".score-visit", ".away .score"]))

    status_short = map_status(raw_status, live_period)

    timestamp = int(datetime.fromisoformat(date_iso).timestamp()) if date_iso else 0

    return {
        "date":      date_iso or "",
        "timestamp": timestamp,
        "week":      round_name,
        "status":    {"short": status_short, "long": status_short},
        "scores": {
            "home": home_score if status_short not in ("NS",) else None,
            "away": away_score if status_short not in ("NS",) else None,
        },
        "teams": {
            "home": {"name": home_name, "logo": home_logo},
            "away": {"name": away_name, "logo": away_logo},
        },
    }


def _extract_scores(livescore: dict) -> tuple[int | None, int | None, str | None]:
    """Extrae marcador y periodo del JSON de livescore de datafactory."""
    # Estructura típica de datafactory livescore:
    # { "score": { "local": 14, "visit": 7 }, "period": "1H" }
    # o: { "localScore": 14, "visitScore": 7, "period": "FirstHalf" }
    score  = livescore.get("score", {})
    local  = score.get("local") or livescore.get("localScore") or livescore.get("local_score")
    visit  = score.get("visit") or livescore.get("visitScore") or livescore.get("visit_score")
    period = livescore.get("period") or livescore.get("status") or livescore.get("time_name")
    return (_int(local), _int(visit), str(period) if period else None)


# ── Helpers ────────────────────────────────────────────────────────────────────

def _text(tag, selectors: list[str]) -> str | None:
    for sel in selectors:
        found = tag.select_one(sel)
        if found:
            return found.get_text(strip=True) or None
    return None


def _logo(tag, selectors: list[str]) -> str | None:
    for sel in selectors:
        img = tag.select_one(sel)
        if img and img.get("src"):
            return img["src"]
    return None


def _int(val) -> int | None:
    try:
        return int(val)
    except (TypeError, ValueError):
        return None


def _parse_date(raw: str | None) -> str | None:
    """Convierte fecha en formato datafactory a ISO 8601 con timezone Argentina."""
    if not raw:
        return None
    # Formatos comunes: "19/04/2026 14:00" o "2026-04-19T14:00:00"
    for fmt in ("%d/%m/%Y %H:%M", "%Y-%m-%dT%H:%M:%S", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M"):
        try:
            dt = datetime.strptime(raw.strip(), fmt)
            return dt.strftime("%Y-%m-%dT%H:%M:%S-03:00")  # Argentina (ART = UTC-3)
        except ValueError:
            continue
    return raw  # devolver raw si no se puede parsear


# ── Main ───────────────────────────────────────────────────────────────────────

def main():
    log.info("Fetching fixture HTML...")
    html = fetch_fixture_html()
    soup = BeautifulSoup(html, "html.parser")

    # Buscar la sección del Top 14 División Superior.
    # datafactory suele tener un header de competencia antes de los partidos.
    top14_section = None
    for header in soup.find_all(["h2", "h3", "h4", "div"], class_=re.compile(r"competition|championship|liga|categoria", re.I)):
        if is_top14_section(header):
            top14_section = header.find_parent() or header.find_next_sibling()
            break

    if top14_section is None:
        # Fallback: buscar todos los partidos de hoy en toda la página
        log.warning("No se encontró sección Top 14. Usando toda la página como fallback.")
        top14_section = soup

    # Encontrar todos los partidos dentro de la sección
    match_tags = top14_section.find_all(
        "div",
        class_=re.compile(r"match|partido|event", re.I),
    )

    # Filtrar solo los de hoy (sábado) y estado NS o inProgress
    today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    matches = []
    for tag in match_tags:
        classes = " ".join(tag.get("class", []))
        if "status-end" in classes:
            continue  # partido ya terminado: la API oficial de URBA tiene el resultado final
        parsed = parse_match(tag)
        if parsed:
            matches.append(parsed)

    log.info(f"Partidos encontrados: {len(matches)}")

    payload = {
        "matches":    matches,
        "updated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
    }

    # PUT al Worker
    put_url = f"{WORKER_URL}/urba-live"
    log.info(f"Subiendo datos a {put_url}...")
    resp = requests.put(
        put_url,
        headers={
            "Content-Type":  "application/json",
            "X-Secret-Token": LIVE_SECRET_TOKEN,
        },
        data=json.dumps(payload),
        timeout=10,
    )
    resp.raise_for_status()
    log.info(f"OK: {resp.json()}")


if __name__ == "__main__":
    main()
