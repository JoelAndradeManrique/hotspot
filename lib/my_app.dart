import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/feature/admin/home/screen/admin_home_screen.dart';
import 'package:hotspot/feature/admin/auth/admin_login_screen.dart';
import 'package:hotspot/feature/user/auth/screen/user_login_screen.dart';
import 'package:hotspot/feature/user/home/screen/bottom_navigation_bar.dart';
import 'package:hotspot/feature/user/home/screen/user_home_screen.dart';
import 'package:hotspot/feature/user/landing/screen/onboarding_screen.dart';
import 'package:hotspot/global.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('authentication error ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return Global.baseUrl == "Admin App"
                  ? const AdminHomeScreen()
                  : const NavigationBarScreen();
            } else {
              return Global.baseUrl == "Admin App"
                  ? const AdminLoginScreen()
                  : const OnboardingScreen();
            }
          },
        ),
      ),
    );
  }
}
