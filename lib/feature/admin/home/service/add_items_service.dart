import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/feature/admin/home/model/add_items_model.dart';

class AddItemsNotifier extends StateNotifier<AddItemsState> {
  AddItemsNotifier() : super(AddItemsState()) {
    _fetchCategory();
  }

  void setSelectedCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSelectedCondition(String? condition) {
    state = state.copyWith(selectedCondition: condition);
  }

  void setSelectedLocation(LatLng? location) {
    state = state.copyWith(selectedLocation: location);
  }

  Future<void> _fetchCategory() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("FishCategory")
        .get();
    final category = snapshot.docs.map((doc) => doc['name'] as String).toList();
    state = state.copyWith(categories: category);
  }

  Future<void> addCategory(String categoryName) async {
    if (categoryName.isEmpty) {
      throw Exception("Condition name cannot be empty");
    }

    final lowercaseCategoryName = categoryName.toLowerCase();
    if (state.categories.any(
      (category) => category.toLowerCase() == lowercaseCategoryName,
    )) {
      throw Exception("Category already exists");
    }
    try {
      await FirebaseFirestore.instance.collection("FishCategory").add({
        'name': categoryName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _fetchCategory();
    } catch (e) {
      throw Exception("Failed to add condition: $e");
    }
  }

  Future<void> saveItems({
    required String locationName,
    required BuildContext context,
  }) async {
    if (locationName.isEmpty ||
        state.selectedCategory == null ||
        state.selectedCondition == null ||
        state.selectedLocation == null) {
      throw Exception("Please fill all the fields");
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      await FirebaseFirestore.instance.collection("hotspot").add({
        'locationName': locationName,
        'category': state.selectedCategory,
        'latitude': state.selectedLocation!.latitude,
        'longitude': state.selectedLocation!.longitude,
        'rating': state.rating,
        'reviewCount': state.reviewCount,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      resetState();
    } catch (e) {
      rethrow;
    }
  }

  void resetState() {
    state = AddItemsState(
      categories: state.categories,
      conditions: state.conditions,
    );
  }
}

final additemProvider = StateNotifierProvider<AddItemsNotifier, AddItemsState>((
  ref,
) {
  return AddItemsNotifier();
});
