importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// Configuración de Firebase para el service worker.
// Estos valores NO son secretos (son el config público del proyecto Firebase).
// Completar con los valores del proyecto Firebase una vez creado.
// Ver: https://console.firebase.google.com → Configuración del proyecto → Web apps
firebase.initializeApp({
  apiKey:            "AIzaSyB2a9md3bvjNTBJg0r5xocHQVzYSM_98PA",
  authDomain:        "rugby-score-65107.firebaseapp.com",
  projectId:         "rugby-score-65107",
  storageBucket:     "rugby-score-65107.firebasestorage.app",
  messagingSenderId: "748860715146",
  appId:             "1:748860715146:web:310dc5b35c42456878fd73",
});

const messaging = firebase.messaging();

// Muestra la notificación cuando la app está cerrada o en background
messaging.onBackgroundMessage((payload) => {
  const { title, body } = payload.notification ?? {};
  if (!title) return;

  return self.registration.showNotification(title, {
    body:  body ?? '',
    icon:  '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    data:  payload.data ?? {},
    vibrate: [200, 100, 200],
  });
});
