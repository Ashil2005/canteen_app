import 'package:flutter/material.dart';
import 'package:canteen_app/constants/colors.dart'; // ✅ use AppColors
import '../login/login_screen.dart'; // ✅ direct navigation to login

class CodeVerificationScreen extends StatelessWidget {
  const CodeVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor, // ✅ Unified background
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.email, size: 80, color: AppColors.primary), // ✅ Orange
                const SizedBox(height: 20),
                Text(
                  'Check Your Email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor, // ✅ consistent text
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "We’ve sent you a password reset link to your email.\n\n"
                  "👉 If you don’t see it in your inbox, please check your Spam or Junk folder.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor, // ✅ consistent text
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // ✅ Orange button
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'Back to Login',
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
