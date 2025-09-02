import 'package:canteen_app/screens/forgotpw/codeverification.dart';
import 'package:flutter/material.dart';

class ForgotPWScreen extends StatelessWidget {
  const ForgotPWScreen({super.key});

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
                SizedBox(height: 20),
                Text("Reset Password", style: TextStyle(fontSize: 24)),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => CodeVerficationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Text('Send Reset Link'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
