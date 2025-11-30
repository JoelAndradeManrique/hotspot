import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/feature/shared/service/google_auth_provider.dart';
import 'package:hotspot/global.dart';

class GoogleLoginScreen extends ConsumerWidget {
  const GoogleLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(googleAuthProvider);
    final authNotifier = ref.read(googleAuthProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.error != null) {
        mySnackBar(message: authState.error!, context: context);
        Future.delayed(const Duration(milliseconds: 100), () {
          ref.read(googleAuthProvider.notifier).clearError();
        });
      }
    });
    return Column(
      children: [
        MaterialButton(
          elevation: 0,
          color: Global.baseUrl == "Admin App"
              ? Colors.white
              : Colors.lightBlueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: authState.isLoading
              ? null
              : () {
                  authNotifier.clearError();
                  authNotifier.signInWithGoogle(context);
                },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://img.icons8.com/color/48/000000/google-logo.png", // <--- URL NUEVA Y FUNCIONAL (PNG)
                  height: 30, // Ajusta el tamaño si es necesario
                  width: 30,
                  errorBuilder: (context, error, stackTrace) {
                    // Esto es por si vuelve a fallar, que muestre un icono en vez de explotar
                    return Icon(Icons.error, color: Colors.red);
                  },
                ),
                SizedBox(width: 15),
                Text(
                  authState.isLoading
                      ? "signing in..."
                      : "Continue with Google",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (authState.isLoading)
          CircularProgressIndicator(
            color: Global.baseUrl == "Admin App" ? Colors.white : Colors.black,
          ),
      ],
    );
  }
}
