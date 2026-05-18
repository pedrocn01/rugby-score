import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _auth = FirebaseAuth.instance;

  Stream<User?> get userStream => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      final result = await _auth.signInWithPopup(GoogleAuthProvider());
      return result.user;
    } catch (e) {
      debugPrint('❌ AuthService.signInWithGoogle: $e');
      return null;
    }
  }

  Future<void> signOut() async => _auth.signOut();
}
