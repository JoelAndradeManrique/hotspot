import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/core/common/widgets/my_button.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/feature/user/auth/screen/user_login_screen.dart';
import 'package:hotspot/feature/user/auth/service/auth_provider.dart';
import 'package:hotspot/feature/user/auth/service/auth_service.dart';
import 'package:hotspot/go_route.dart';

class SingupScreen extends ConsumerWidget {
  const SingupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(authFormProvider);
    final formNotifer = ref.read(authFormProvider.notifier);
    final AuthMethod = ref.read(AuthMethodProvider);
    void sigup() async {
      formNotifer.setLoading(true);
      final res = await AuthMethod.singUpUser(
        email: formState.email,
        password: formState.password,
        name: formState.name,
      );
      formNotifer.setLoading(false);
      if (res == "success") {
        NavigationHelper.pushReplacement(context, UserLoginScreen());
        mySnackBar(
          message: "Sinup Up Successful, now turn to login",
          context: context,
        );
      } else {
        mySnackBar(message: res, context: context);
      }
    }

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: height / 2.3,
              width: double.maxFinite,
              decoration: BoxDecoration(),
              child: Image.asset("assets/login/imagen2.png", fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    autocorrect: false,
                    onChanged: (value) => formNotifer.updateName(value),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Enter your name",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15),
                      errorText: formState.nameError,
                    ),
                  ),
                  SizedBox(height: 15),
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
                          onTab: formState.isFormvalid ? sigup : null,
                          buttonText: "sing Up",
                        ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      Text("Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          NavigationHelper.push(context, UserLoginScreen());
                        },
                        child: Text(
                          "Login",
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
