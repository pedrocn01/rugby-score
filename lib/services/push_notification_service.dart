import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../config/firebase_options.dart';
import 'notifications_service.dart';

class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  String? _fcmToken;

  Future<void> init() async {
    if (!kIsWeb || !DefaultFirebaseOptions.isConfigured) return;

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _refreshToken();
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      _fcmToken = token;
      await _syncToFirestore();
    });
  }

  // Llamar cuando el usuario toca el ícono de campana.
  // Pide permiso si todavía no fue otorgado, luego togglea la suscripción.
  Future<bool> toggleTeam(String teamName) async {
    if (!DefaultFirebaseOptions.isConfigured) {
      // Firebase no configurado: solo guarda preferencia local
      await NotificationsService.instance.toggle(teamName);
      return true;
    }

    if (_fcmToken == null) {
      final granted = await _requestPermission();
      if (!granted) return false;
    }

    await NotificationsService.instance.toggle(teamName);
    await _syncToFirestore();
    return true;
  }

  Future<bool> _requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _refreshToken();
      return true;
    }
    return false;
  }

  Future<void> _refreshToken() async {
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey: const String.fromEnvironment('FIREBASE_VAPID_KEY'),
      );
      await _syncToFirestore();
    } catch (e) {
      debugPrint('❌ PushNotificationService._refreshToken(): $e');
    }
  }

  // Guarda en Firestore: {token} -> {teams: [...], platform: 'web'}
  // El script Python lee esta colección para saber a quién notificar.
  Future<void> _syncToFirestore() async {
    final token = _fcmToken;
    if (token == null) return;

    try {
      final teams = NotificationsService.instance.teams;
      final doc = FirebaseFirestore.instance
          .collection('subscriptions')
          .doc(token);

      if (teams.isEmpty) {
        await doc.delete();
      } else {
        await doc.set({
          'teams':     teams,
          'updatedAt': FieldValue.serverTimestamp(),
          'platform':  'web',
        });
      }
    } catch (e) {
      debugPrint('❌ PushNotificationService._syncToFirestore(): $e');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('▶ PushNotificationService: mensaje en foreground: ${message.notification?.title}');
    // En web, el browser maneja la notificación visual automáticamente.
    // Aquí se puede mostrar un snackbar si la app está abierta.
  }
}
