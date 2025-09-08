import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Firebase
import 'package:canteen_app/firebase_options.dart';

// Core screens
import 'package:canteen_app/screens/splash/splash_screen.dart';
import 'package:canteen_app/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_app/screens/login/login_screen.dart';
import 'package:canteen_app/screens/register/register_screen.dart';
import 'package:canteen_app/screens/forgotpw/forgotpw.dart';
import 'package:canteen_app/screens/forgotpw/codeverification.dart';
import 'package:canteen_app/profile_page.dart';

// Student flow
import 'package:canteen_app/student_home.dart';
import 'package:canteen_app/cart_page.dart';
import 'package:canteen_app/order_page.dart';
// NOTE: file name preserved to match your repo
import 'package:canteen_app/BillPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CanteenApp());
}

class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgot = '/forgot';
  static const codeVerification = '/check-email';
  static const onboarding = '/onboarding';
  static const profile = '/profile';

  static const studentHome = '/student-home';
  static const cart = '/cart';
  static const order = '/order';
  static const bill = '/bill';
}

class CanteenApp extends StatelessWidget {
  const CanteenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canteen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),

      // FLOW (final):
      // Splash  -> (auto after delay) -> Login
      // Login   -> (on success)       -> Onboarding
      // Onboard -> (Get Started)      -> StudentHome
      initialRoute: Routes.splash,

      // Simple routes (no arguments)
      routes: {
        Routes.splash: (_) => const SplashScreen(),          // must navigate to Routes.login after delay
        Routes.login: (_) => LoginScreen(),                  // should navigate to Routes.onboarding on success
        Routes.register: (_) => RegisterScreen(),
        Routes.forgot: (_) => const ForgotPWScreen(),
        Routes.codeVerification: (_) => const CodeVerificationScreen(),
        Routes.onboarding: (_) => const OnboardingScreen(),  // should navigate to Routes.studentHome
        Routes.profile: (_) => const ProfilePage(),
        Routes.studentHome: (_) => const StudentMenuPage(),
      },

      // Routes that need arguments
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.cart:
            // args: { selectedItems: List, quantities: Map<String,int> }
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => CartPage(
                selectedItems: args['selectedItems'],
                quantities: args['quantities'],
              ),
            );

          case Routes.order:
            // args: { item: dynamic }
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => OrderPage(item: args['item']),
            );

          case Routes.bill:
            // args: { cartItems: List, quantities: Map<String,int> }
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => BillPage(
                cartItems: args['cartItems'],
                quantities: args['quantities'],
              ),
            );
        }
        return null;
      },
    );
  }
}
