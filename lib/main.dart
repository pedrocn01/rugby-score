import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'services/favorites_service.dart';
import 'services/notifications_service.dart';
import 'services/push_notification_service.dart';
import 'widgets/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesService.instance.init();
  await NotificationsService.instance.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationService.instance.init();
  runApp(const RugbyApp());
}

class RugbyApp extends StatelessWidget {
  const RugbyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                    'Rugby Score',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:           ColorScheme.fromSeed(seedColor: const Color(0xFF1B4332)),
        useMaterial3:          true,
        fontFamily:            'Georgia',
        scaffoldBackgroundColor: const Color(0xFFF7F3EE),
      ),
      home: const MainShell(),
    );
  }
}
