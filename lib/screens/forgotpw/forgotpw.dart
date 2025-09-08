import 'package:flutter/material.dart';
import 'package:canteen_app/auth/auth_service.dart';
import 'package:canteen_app/constants/colors.dart'; // ✅ use AppColors
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Reset link sent! Check your email.')),
      );

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
      backgroundColor: AppColors.bgColor, // ✅ unified background
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.lock_reset, size: 80, color: AppColors.primary), // ✅ orange
                const SizedBox(height: 20),
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor, // ✅ black text
                  ),
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
                          backgroundColor: AppColors.primary, // ✅ orange button
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text(
                          'Send Reset Link',
                          style: TextStyle(color: Colors.white), // ✅ contrast
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
