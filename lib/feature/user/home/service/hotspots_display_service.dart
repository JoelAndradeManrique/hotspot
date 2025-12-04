import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hotspot/feature/shared/Model/disply_items_model.dart';

final hotspotsProvider = StreamProvider<List<Hotspot>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection("hotspot")
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

//provider to stream fish categories from firestore

final fishCategoriesProvider = StreamProvider<List<String>>((ref) {
  return FirebaseFirestore.instance
      .collection("FishCategory")
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => doc['name'] as String).toList(),
      );
});

//state provider for selected fish categories (null = show all)
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
//state provider for selected hotspot marker (null = show all)
final selectedMarkerProvider = StateProvider<Hotspot?>((ref) => null);
