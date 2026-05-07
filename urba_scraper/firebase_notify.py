"""
Envía notificaciones push via Firebase cuando cambian los scores en vivo.

Flujo:
  1. Lee los scores actuales del Worker de Cloudflare (misma fuente que la app)
  2. Compara con los scores anteriores guardados en Firestore
  3. Si un score cambió, busca en Firestore qué tokens siguen ese equipo
  4. Envía la notificación push a esos tokens via FCM

Variables de entorno requeridas:
  WORKER_URL              → URL del Worker (igual que en datafactory_live.py)
  LIVE_SECRET_TOKEN       → Token secreto del Worker
  FIREBASE_SERVICE_ACCOUNT → JSON completo de la service account de Firebase Admin
                             (copiado desde Firebase Console → Configuración → Cuentas de servicio)
"""

import json
import logging
import os

import firebase_admin
import requests
from firebase_admin import credentials, firestore, messaging

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
log = logging.getLogger(__name__)

WORKER_URL        = os.environ["WORKER_URL"].rstrip("/")
LIVE_SECRET_TOKEN = os.environ["LIVE_SECRET_TOKEN"].strip()

# ─── Inicializar Firebase Admin ───────────────────────────────────────────────

def _init_firebase():
    if firebase_admin._apps:
        return
    service_account = json.loads(os.environ["FIREBASE_SERVICE_ACCOUNT"])
    cred = credentials.Certificate(service_account)
    firebase_admin.initialize_app(cred)

# ─── Obtener scores actuales del Worker ───────────────────────────────────────

def _fetch_live_scores() -> dict:
    """Retorna {match_id: {home, away, score_home, score_away}} para partidos en vivo."""
    try:
        resp = requests.get(
            f"{WORKER_URL}/urba-live",
            headers={"Authorization": f"Bearer {LIVE_SECRET_TOKEN}"},
            timeout=10,
        )
        resp.raise_for_status()
        data = resp.json()
        scores = {}
        for match in data if isinstance(data, list) else data.get("matches", []):
            status = match.get("status", {}).get("short", "")
            if status not in {"1H", "2H", "HT", "ET", "BT", "P"}:
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
                    "score_home": score_h,
                    "score_away": score_a,
                }
        return scores
    except Exception as e:
        log.error("❌ Error fetching live scores: %s", e)
        return {}

# ─── Leer / escribir scores previos en Firestore ──────────────────────────────

def _get_previous_scores(db) -> dict:
    doc = db.collection("_internal").document("previous_scores").get()
    return doc.to_dict().get("scores", {}) if doc.exists else {}

def _save_current_scores(db, scores: dict):
    db.collection("_internal").document("previous_scores").set({"scores": scores})

# ─── Enviar notificaciones ────────────────────────────────────────────────────

def _notify_team(db, team_name: str, title: str, body: str):
    """Busca todos los tokens suscritos a ese equipo y envía la notificación."""
    tokens_ref = db.collection("subscriptions").where("teams", "array_contains", team_name)
    docs = tokens_ref.stream()

    tokens = [doc.id for doc in docs]
    if not tokens:
        log.info("  Sin suscriptores para %s", team_name)
        return

    # FCM multicast (máx 500 tokens por llamada)
    for i in range(0, len(tokens), 500):
        batch = tokens[i:i + 500]
        response = messaging.send_each_for_multicast(
            messaging.MulticastMessage(
                tokens=batch,
                notification=messaging.Notification(title=title, body=body),
                android=messaging.AndroidConfig(priority="high"),
                apns=messaging.APNSConfig(
                    payload=messaging.APNSPayload(
                        aps=messaging.Aps(sound="default")
                    )
                ),
            )
        )
        log.info(
            "  Notificación enviada a %s: %d éxitos, %d fallos",
            team_name, response.success_count, response.failure_count,
        )

# ─── Main ──────────────────────────────────────────────────────────────────────

def main():
    _init_firebase()
    db = firestore.client()

    current  = _fetch_live_scores()
    previous = _get_previous_scores(db)

    if not current:
        log.info("Sin partidos en vivo.")
        return

    for match_id, cur in current.items():
        prev = previous.get(match_id)

        if prev is None:
            # Partido nuevo en vivo
            for team in [cur["home"], cur["away"]]:
                log.info("▶ Partido iniciado: %s vs %s", cur["home"], cur["away"])
                _notify_team(
                    db, team,
                    title=f"🏉 Partido en vivo",
                    body=f"{cur['home']} {cur['score_home']} - {cur['score_away']} {cur['away']}",
                )
        elif cur["score_home"] != prev["score_home"] or cur["score_away"] != prev["score_away"]:
            # Cambió el score — notificar a ambos equipos
            score_text = f"{cur['home']} {cur['score_home']} - {cur['score_away']} {cur['away']}"
            for team in [cur["home"], cur["away"]]:
                log.info("▶ Score cambió para %s: %s", team, score_text)
                _notify_team(
                    db, team,
                    title=f"🏉 Cambio de score",
                    body=score_text,
                )

    _save_current_scores(db, current)
    log.info("✅ Notificaciones procesadas.")

if __name__ == "__main__":
    main()
