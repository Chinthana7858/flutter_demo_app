import 'package:flutter/material.dart';
import 'package:my_demo_app/presentation/screens/sign_up_screen.dart';
import 'package:my_demo_app/presentation/screens/home_screen.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/login_screen.dart';

void main() => runApp(
  
  const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => LoginScreen(),
        AppRoutes.signup: (_) => SignUpScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
      },
    );
  }
}
