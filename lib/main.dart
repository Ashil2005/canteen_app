import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Comment this if firebase_options.dart is not yet generated
import 'firebase_options.dart';

import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only if firebase_options.dart exists
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(CanteenApp());
}

class CanteenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canteen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
