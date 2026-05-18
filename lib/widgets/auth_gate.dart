import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/onboarding_page.dart';
import '../services/user_service.dart';
import 'main_shell.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _lastUid;
  Future<void>? _loadFuture;
  bool _authTimedOut = false;

  @override
  void initState() {
    super.initState();
    UserService.instance.addListener(_onProfileChanged);
    // Safety valve: if the auth stream never emits, bail to login after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted && !_authTimedOut) setState(() => _authTimedOut = true);
    });
  }

  @override
  void dispose() {
    UserService.instance.removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onProfileChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Use currentUser synchronously while stream initialises —
        // avoids the splash on cached sessions.
        final User? user = snapshot.data ??
            (snapshot.connectionState == ConnectionState.waiting
                ? FirebaseAuth.instance.currentUser
                : null);

        if (snapshot.connectionState == ConnectionState.waiting && user == null) {
          return _authTimedOut ? const LoginPage() : const _Splash();
        }

        if (user == null) {
          _lastUid = null;
          _loadFuture = null;
          UserService.instance.clearProfile();
          return const LoginPage();
        }

        if (UserService.instance.profile != null) {
          return const MainShell();
        }

        if (_lastUid != user.uid) {
          _lastUid = user.uid;
          _loadFuture = UserService.instance.loadProfile(user.uid);
        }

        return FutureBuilder<void>(
          future: _loadFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const _Splash();
            }
            if (UserService.instance.profile != null) {
              return const MainShell();
            }
            return OnboardingPage(uid: user.uid);
          },
        );
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4CAF50),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
