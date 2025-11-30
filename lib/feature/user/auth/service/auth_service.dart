import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> singUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return "Please enter all fields";
      }
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'uid': cred.user!.uid,
        'email': email,
        'cretedAt': FieldValue.serverTimestamp(),
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  //login user
    Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please enter all fields";
      }
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  //logout
  Future<void> singOut() async {
    await _auth.signOut();
  }
}

final AuthMethodProvider = Provider<AuthMethod>((ref) {
  return AuthMethod();
}); 
