"""
Envía notificaciones push via Firebase cuando cambian scores en vivo.

Cubre TODAS las ligas de la app:
  - Internacionales: consulta el Worker proxy en rugby-proxy.pedrocastronevares.workers.dev
  - URBA: consulta el endpoint /urba-live del Worker de Cloudflare

Variables de entorno requeridas:
  FIREBASE_SERVICE_ACCOUNT → JSON completo de la service account de Firebase Admin

Variables opcionales:
  WORKER_URL              → URL del Worker de URBA (para /urba-live)
  LIVE_SECRET_TOKEN       → Token para autenticar /urba-live
  APP_SECRET              → Secreto para el proxy internacional (si está configurado en Cloudflare)
"""

import json
import logging
import os

import firebase_admin
import requests
from firebase_admin import credentials, firestore, messaging

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
log = logging.getLogger(__name__)

WORKER_URL        = os.environ.get("WORKER_URL", "").rstrip("/")
LIVE_SECRET_TOKEN = os.environ.get("LIVE_SECRET_TOKEN", "").strip()
RUGBY_PROXY_URL   = "https://rugby-proxy.pedrocastronevares.workers.dev"
APP_SECRET        = os.environ.get("APP_SECRET", "").strip()

LIVE_STATUSES = {"1H", "2H", "HT", "ET", "BT", "P"}

# ─── Inicializar Firebase Admin ───────────────────────────────────────────────

def _init_firebase():
    if firebase_admin._apps:
        return
    service_account = json.loads(os.environ["FIREBASE_SERVICE_ACCOUNT"])
    cred = credentials.Certificate(service_account)
    firebase_admin.initialize_app(cred)

# ─── Obtener scores en vivo internacionales ───────────────────────────────────

def _fetch_international_live() -> dict:
    """Llama al Worker proxy para traer todos los partidos internacionales en vivo."""
    try:
        headers = {"Accept": "application/json"}
        if APP_SECRET:
            headers["X-App-Secret"] = APP_SECRET

        resp = requests.get(
            f"{RUGBY_PROXY_URL}/games",
            params={"live": "all"},
            headers=headers,
            timeout=15,
        )
        resp.raise_for_status()
        data = resp.json()

        scores = {}
        matches = data.get("response", []) if isinstance(data, dict) else []
        for match in matches:
            status = match.get("status", {}).get("short", "")
            if status not in LIVE_STATUSES:
                continue
            match_id  = str(match.get("id", ""))
            home_name = match.get("teams", {}).get("home", {}).get("name", "")
            away_name = match.get("teams", {}).get("away", {}).get("name", "")
            score_h   = match.get("scores", {}).get("home") or 0
            score_a   = match.get("scores", {}).get("away") or 0
            if match_id and home_name:
                scores[match_id] = {
                    "home":       home_name,
                    "away":       away_name,
                    "score_home": int(score_h),
                    "score_away": int(score_a),
                    "source":     "international",
                }
        log.info("Internacional: %d partidos en vivo", len(scores))
        return scores
    except Exception as e:
        log.error("❌ Error fetching international live scores: %s", e)
        return {}

# ─── Obtener scores en vivo URBA ─────────────────────────────────────────────

def _fetch_urba_live() -> dict:
    """Llama al Worker de URBA para traer los partidos URBA en vivo."""
    if not WORKER_URL or not LIVE_SECRET_TOKEN:
        return {}
    try:
        resp = requests.get(
            f"{WORKER_URL}/urba-live",
            headers={"Authorization": f"Bearer {LIVE_SECRET_TOKEN}"},
            timeout=10,
        )
        resp.raise_for_status()
        data = resp.json()

        scores = {}
        matches = data if isinstance(data, list) else data.get("matches", [])
        for match in matches:
            status = match.get("status", {}).get("short", "")
            if status not in LIVE_STATUSES:
                continue
            match_id  = str(match.get("id", ""))
            home_name = match.get("teams", {}).get("home", {}).get("name", "")
            away_name = match.get("teams", {}).get("away", {}).get("name", "")
            score_h   = match.get("scores", {}).get("home") or 0
            score_a   = match.get("scores", {}).get("away") or 0
            if match_id and home_name:
                scores[match_id] = {
                    "home":       home_name,
                    "away":       away_name,
                    "score_home": int(score_h),
                    "score_away": int(score_a),
                    "source":     "urba",
                }
        log.info("URBA: %d partidos en vivo", len(scores))
        return scores
    except Exception as e:
        log.error("❌ Error fetching URBA live scores: %s", e)
        return {}

# ─── Firestore: scores anteriores ────────────────────────────────────────────

def _get_previous_scores(db) -> dict:
    doc = db.collection("_internal").document("previous_scores").get()
    return doc.to_dict().get("scores", {}) if doc.exists else {}

def _save_current_scores(db, scores: dict):
    db.collection("_internal").document("previous_scores").set({"scores": scores})

# ─── Enviar notificaciones ────────────────────────────────────────────────────

def _notify_team(db, team_name: str, title: str, body: str):
    """Busca tokens suscritos a ese equipo y manda la notificación push."""
    tokens_ref = db.collection("subscriptions").where("teams", "array_contains", team_name)
    tokens = [doc.id for doc in tokens_ref.stream()]

    if not tokens:
        log.info("  Sin suscriptores para '%s'", team_name)
        return

    for i in range(0, len(tokens), 500):
        batch = tokens[i:i + 500]
        response = messaging.send_each_for_multicast(
            messaging.MulticastMessage(
                tokens=batch,
                notification=messaging.Notification(title=title, body=body),
                android=messaging.AndroidConfig(priority="high"),
                apns=messaging.APNSConfig(
                    payload=messaging.APNSPayload(aps=messaging.Aps(sound="default"))
                ),
            )
        )
        log.info(
            "  → '%s': %d enviadas, %d fallidas",
            team_name, response.success_count, response.failure_count,
        )

def _process_matches(db, current: dict, previous: dict):
    """Compara scores actuales vs anteriores y manda notificaciones si cambiaron."""
    for match_id, cur in current.items():
        prev = previous.get(match_id)
        score_text = f"{cur['home']} {cur['score_home']} - {cur['score_away']} {cur['away']}"

        if prev is None:
            # Partido nuevo en vivo
            log.info("▶ Partido iniciado: %s", score_text)
            for team in [cur["home"], cur["away"]]:
                _notify_team(db, team,
                    title="🏉 Partido en vivo",
                    body=score_text)
        elif cur["score_home"] != prev["score_home"] or cur["score_away"] != prev["score_away"]:
            # Score cambió
            log.info("▶ Score cambió: %s", score_text)
            for team in [cur["home"], cur["away"]]:
                _notify_team(db, team,
                    title="🏉 Cambio de score",
                    body=score_text)

# ─── Main ──────────────────────────────────────────────────────────────────────

def main():
    _init_firebase()
    db = firestore.client()

    # Traer scores actuales de todas las fuentes
    current = {}
    current.update(_fetch_international_live())
    current.update(_fetch_urba_live())

    if not current:
        log.info("Sin partidos en vivo en este momento.")
        return

    previous = _get_previous_scores(db)
    _process_matches(db, current, previous)
    _save_current_scores(db, current)
    log.info("✅ Listo.")

if __name__ == "__main__":
    main()
