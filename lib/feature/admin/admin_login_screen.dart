import 'package:flutter/material.dart';
import 'package:hotspot/feature/shared/screen/google_login_screen.dart';
import 'package:lottie/lottie.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AdminLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Stack(
        children: [
          Positioned(
            left: -80,
            child: Lottie.network(
              "https://lottie.host/d7687766-2c66-4dea-8dac-bb3573830791/r6HvnhyX6f.json",
              width: 500,
              height: 450,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return SizedBox(width: 500, height: 400);
              },
            ),
          ),

          Positioned(
            bottom: 180,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GoogleLoginScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
