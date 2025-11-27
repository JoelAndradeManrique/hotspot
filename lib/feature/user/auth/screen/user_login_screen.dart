import 'package:flutter/material.dart';
import 'package:hotspot/core/common/widgets/my_button.dart';
import 'package:hotspot/core/theme/color.dart';
import 'package:hotspot/feature/user/auth/screen/singup_screen.dart';
import 'package:hotspot/go_route.dart';

class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: height / 2.3,
            width: double.maxFinite,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: shadowColor, blurRadius: 15, spreadRadius: 20),
              ],
            ),
            child: Image.asset("assets/login/imagen1.png", fit: BoxFit.cover),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Enter your email",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Enter your password",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 20),
                MyButton(onTab: () {}, buttonText: "Login"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Spacer(),
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        NavigationHelper.push(context, SingupScreen());
                      },
                      child: Text(
                        "sing Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
