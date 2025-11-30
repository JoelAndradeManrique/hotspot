// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/core/common/widgets/my_button.dart';
import 'package:hotspot/core/theme/color.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/feature/user/auth/screen/singup_screen.dart';
import 'package:hotspot/feature/user/auth/service/auth_provider.dart';
import 'package:hotspot/feature/user/auth/service/auth_service.dart';
import 'package:hotspot/feature/user/home/home_screen.dart';
import 'package:hotspot/go_route.dart';

class UserLoginScreen extends ConsumerWidget {
  const UserLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    final formState = ref.watch(authFormProvider);
    final formNotifer = ref.read(authFormProvider.notifier);
    final AuthMethod = ref.read(AuthMethodProvider);
    void loginin() async {
      formNotifer.setLoading(true);
      final res = await AuthMethod.loginUser(
        email: formState.email,
        password: formState.password,
      );
      formNotifer.setLoading(false);
      if (res == "success") {
        NavigationHelper.pushReplacement(context, HomeScreen());
        mySnackBar(message: "Successful login", context: context);
      } else {
        mySnackBar(message: res, context: context);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height / 2.3,
              width: double.maxFinite,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 15,
                    spreadRadius: 20,
                  ),
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
                    onChanged: (value) => formNotifer.updateEmail(value),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Enter your email",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15),
                      errorText: formState.emailError,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    autocorrect: false,
                    onChanged: (value) => formNotifer.updatePassword(value),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: formState.isPasswordHidden,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Enter your password",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15),
                      errorText: formState.passwordError,
                      suffixIcon: IconButton(
                        onPressed: () => formNotifer.togglePasswordVisibility(),
                        icon: Icon(
                          formState.isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  formState.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : MyButton(
                          onTab: formState.isFormvalid ? loginin : null,
                          buttonText: "Login",
                        ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: Colors.black26),
                      ),
                      Text("  OR  "),
                      Expanded(
                        child: Container(height: 1, color: Colors.black26),
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
