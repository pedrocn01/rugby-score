import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'services/favorites_service.dart';
import 'widgets/auth_gate.dart';

class _SmoothTransitionsBuilder extends PageTransitionsBuilder {
  const _SmoothTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FavoritesService.instance.init();
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
        colorScheme:             ColorScheme.fromSeed(seedColor: const Color(0xFF1B4332)),
        useMaterial3:            true,
        fontFamily:              'Georgia',
        scaffoldBackgroundColor: const Color(0xFFF7F3EE),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: _SmoothTransitionsBuilder(),
            TargetPlatform.iOS:     _SmoothTransitionsBuilder(),
            TargetPlatform.linux:   _SmoothTransitionsBuilder(),
            TargetPlatform.macOS:   _SmoothTransitionsBuilder(),
            TargetPlatform.windows: _SmoothTransitionsBuilder(),
          },
        ),
      ),
      home: const AuthGate(),
    );
  }
}
