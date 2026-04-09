import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(const RugbyApp());

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
      home: const HomePage(),
    );
  }
}
