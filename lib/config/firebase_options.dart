import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  // Solo es true cuando se pasan las variables de entorno de Firebase en el build
  static bool get isConfigured =>
      const String.fromEnvironment('FIREBASE_API_KEY').isNotEmpty;

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError('Solo web está soportado');
  }

  // Los valores vienen de las variables de entorno del build (vercel-build.sh)
  // No son secretos: son el config público de Firebase (equivalente al script en index.html)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey:            String.fromEnvironment('FIREBASE_API_KEY'),
    appId:             String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    projectId:         String.fromEnvironment('FIREBASE_PROJECT_ID'),
    authDomain:        String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    storageBucket:     String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
    measurementId:     String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
  );
}
