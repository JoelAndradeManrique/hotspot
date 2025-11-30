import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hotspot/feature/shared/Model/google_auth_model.dart';
import 'package:hotspot/feature/shared/service/google_auth_service.dart';
import 'package:hotspot/feature/user/home/home_screen.dart';

class GoogleAuthNotifier extends StateNotifier<GoogleAuthState> {
  final FirebaseServices _firebaseServices;

  GoogleAuthNotifier(this._firebaseServices) : super(GoogleAuthState());

  Future<void> signInWithGoogle(BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _firebaseServices.singInWithGoogle();

      if (result) {
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

        // Simulate a delay for better UX
      } else {
        state = state.copyWith(error: "Google Sign-In caneled");
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Google Sign-In failed ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final googleAuthProvider =
    StateNotifierProvider<GoogleAuthNotifier, GoogleAuthState>((ref) {
      final firebaseServices = ref.read(firebaseServiceProvider);
      return GoogleAuthNotifier(firebaseServices);
    });
