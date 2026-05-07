importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// Configuración de Firebase para el service worker.
// Estos valores NO son secretos (son el config público del proyecto Firebase).
// Completar con los valores del proyecto Firebase una vez creado.
// Ver: https://console.firebase.google.com → Configuración del proyecto → Web apps
firebase.initializeApp({
  apiKey:            "REEMPLAZAR_CON_FIREBASE_API_KEY",
  authDomain:        "REEMPLAZAR_CON_FIREBASE_AUTH_DOMAIN",
  projectId:         "REEMPLAZAR_CON_FIREBASE_PROJECT_ID",
  storageBucket:     "REEMPLAZAR_CON_FIREBASE_STORAGE_BUCKET",
  messagingSenderId: "REEMPLAZAR_CON_FIREBASE_MESSAGING_SENDER_ID",
  appId:             "REEMPLAZAR_CON_FIREBASE_APP_ID",
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
