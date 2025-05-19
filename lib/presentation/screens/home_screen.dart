import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_demo_app/const/colors.dart';
import 'package:my_demo_app/const/screen_size.dart';
import 'package:my_demo_app/const/app_assets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleExitApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                'Home',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(AppAssets.logo, height: ScreenSize.height * 0.1),
              const SizedBox(height: 40),

              OutlinedButton.icon(
                onPressed: _handleExitApp,
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
