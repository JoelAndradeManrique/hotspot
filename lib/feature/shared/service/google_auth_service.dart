import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future<bool> singInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? signInUser = await googleSignIn.signIn();
      if (signInUser == null) {
        print('User Canceled Google Sign-In');
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await signInUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Missing Google Auth Token');
        return false;
      }

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(authCredential);
      final User? user = userCredential.user;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          await userDoc.set({
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'photoUrl': user.photoURL ?? '',
            'provider': 'google',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return true;
    } on FirebaseAuthException catch (e) {
      print('Google Sign-In Error: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      print('Unexpected Error: $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }

  void singOutUser() async {
    await auth.signOut();

    final isGoogleSignedIn = await googleSignIn.isSignedIn();
    if (isGoogleSignedIn) {
      await googleSignIn.signOut();
    }
  }
}

final firebaseServiceProvider = Provider<FirebaseServices>((ref) {
  return FirebaseServices();
});
