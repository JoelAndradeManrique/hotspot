import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/feature/shared/Model/disply_items_model.dart';

final adminHotSpots = StreamProvider<List<Hotspot>>((ref) {
  final user = ref.watch(authStateProvider).value;
  //if no user is logged in return an empty list
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection("hotspot")
      //query the hotspot collection where createdBy matches the user's uid
      //only display those items on it admin dashboard screen where created by itself
      .where("createdBy", isEqualTo: user.uid)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Hotspot.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList(),
      );
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
