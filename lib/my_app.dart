import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/feature/admin/admin_login_screen.dart';
import 'package:hotspot/feature/user/auth/screen/user_login_screen.dart';
import 'package:hotspot/global.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Global.baseUrl == "Admin App"
            ? const AdminLoginScreen()
            : Global.baseUrl == "User App"
            ? const UserLoginScreen()
            : const Scaffold(
                body: Center(child: Text('Invalid Flavor Configuration')),
              ),
      ),
    );
  }
}
