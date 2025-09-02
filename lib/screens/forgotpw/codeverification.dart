import 'package:flutter/material.dart';

class CodeVerficationScreen extends StatelessWidget {
  const CodeVerficationScreen({super.key});

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
                Icon(Icons.code, size: 80, color: Colors.amber[800]),
                SizedBox(height: 20),
                Text("Enter Verification Code", style: TextStyle(fontSize: 24)),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle code verification logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Text('Verify Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}