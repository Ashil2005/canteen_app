import 'package:flutter/material.dart';
import 'package:canteen_app/auth/auth_service.dart';
import 'codeverification.dart';

class ForgotPWScreen extends StatefulWidget {
  const ForgotPWScreen({super.key});

  @override
  State<ForgotPWScreen> createState() => _ForgotPWScreenState();
}

class _ForgotPWScreenState extends State<ForgotPWScreen> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please enter a valid email')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final String? error = await _authService.sendPasswordResetEmail(email);
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (error == null) {
      // ✅ Show confirmation snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Reset link sent! Check your email.')),
      );

      // ✅ Navigate to info screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CodeVerificationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDEBA),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.lock_reset, size: 80, color: Colors.amber[800]),
                const SizedBox(height: 20),
                const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _sendResetLink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[600],
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Send Reset Link'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
