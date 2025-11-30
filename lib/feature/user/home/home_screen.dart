import 'package:flutter/material.dart';
import 'package:hotspot/feature/user/auth/screen/user_login_screen.dart';
import 'package:hotspot/feature/user/auth/service/auth_service.dart';
import 'package:hotspot/go_route.dart';

AuthMethod authMethod = AuthMethod();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authMethod.singOut();
            NavigationHelper.pushReplacement(context, UserLoginScreen());
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
