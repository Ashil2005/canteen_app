import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';
import '../../constants/colors.dart'; // ✅ Use AppColors

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();

    // Navigate back to login screen and clear history
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _editProfile(BuildContext context) {
    // For now, just show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Edit Profile coming soon!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Profile Picture Placeholder
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Name
                const Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 5),

                // Email
                const Text(
                  "johndoe@example.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 30),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _editProfile(context),
                    child: const Text("Edit Profile"),
                  ),
                ),
                const SizedBox(height: 10),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppColors.primary, 
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _logout(context),
                    child: const Text("Logout"),
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
