import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError('Solo la plataforma web está soportada.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey:            'AIzaSyB2a9md3bvjNTBJg0r5xocHQVzYSM_98PA',
    appId:             '1:748860715146:web:310dc5b35c42456878fd73',
    messagingSenderId: '748860715146',
    projectId:         'rugby-score-65107',
    authDomain:        'rugby-score-65107.firebaseapp.com',
    storageBucket:     'rugby-score-65107.firebasestorage.app',
  );
}
