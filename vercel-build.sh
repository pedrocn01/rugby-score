#!/bin/bash
set -e

export PUB_CACHE="$HOME/.pub-cache"
export FLUTTER_ROOT="$HOME/flutter"

if [ ! -d "$FLUTTER_ROOT" ]; then
  echo "Instalando Flutter..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_ROOT"
fi

export PATH="$PATH:$FLUTTER_ROOT/bin"

flutter config --enable-web
flutter pub get
flutter build web --release \
  --dart-define=API_BASE_URL="${API_BASE_URL:-}" \
  --dart-define=API_KEY= \
  --dart-define=APP_SECRET="${APP_SECRET:-}" \
  --dart-define=FIREBASE_API_KEY="${FIREBASE_API_KEY:-}" \
  --dart-define=FIREBASE_APP_ID="${FIREBASE_APP_ID:-}" \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID="${FIREBASE_MESSAGING_SENDER_ID:-}" \
  --dart-define=FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID:-}" \
  --dart-define=FIREBASE_AUTH_DOMAIN="${FIREBASE_AUTH_DOMAIN:-}" \
  --dart-define=FIREBASE_STORAGE_BUCKET="${FIREBASE_STORAGE_BUCKET:-}" \
  --dart-define=FIREBASE_MEASUREMENT_ID="${FIREBASE_MEASUREMENT_ID:-}" \
  --dart-define=FIREBASE_VAPID_KEY="${FIREBASE_VAPID_KEY:-}"
