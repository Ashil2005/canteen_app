import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Register (you’ll use this soon)
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Check login state (optional use)
  Stream<User?> get userChanges => _auth.authStateChanges();
}
