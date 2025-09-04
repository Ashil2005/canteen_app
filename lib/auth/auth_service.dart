import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // for kReleaseMode

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Unexpected login error: $e');
      return null;
    }
  }

  // ✅ Register
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Register error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Unexpected register error: $e');
      return null;
    }
  }

  // ✅ Forgot Password (with optional continue URL)
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      // Only add ActionCodeSettings in release mode (production hosting)
      if (kReleaseMode) {
        final settings = ActionCodeSettings(
          url: 'https://canteen-app.web.app/#/login', // replace with your hosting URL
          handleCodeInApp: false, // Firebase-hosted reset page
        );

        await _auth.sendPasswordResetEmail(
          email: email,
          actionCodeSettings: settings,
        );
      } else {
        // Dev mode → simpler
        await _auth.sendPasswordResetEmail(email: email);
      }
      return null; // null = success
    } on FirebaseAuthException catch (e) {
      debugPrint('Reset email error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'invalid-email':
          return 'That email address looks invalid.';
        case 'user-not-found':
          return 'No account exists for that email.';
        default:
          return 'Could not send reset email: ${e.message ?? e.code}';
      }
    } catch (e) {
      debugPrint('Unexpected reset email error: $e');
      return 'Something went wrong. Try again later.';
    }
  }

  // ✅ Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ✅ Stream to listen for auth changes
  Stream<User?> get userChanges => _auth.authStateChanges();
}
