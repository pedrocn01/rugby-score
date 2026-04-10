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
flutter build web --release --web-renderer html --dart-define=API_BASE_URL="${API_BASE_URL:-}" --dart-define=API_KEY=
