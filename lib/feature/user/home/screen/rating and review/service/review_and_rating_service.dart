import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/feature/shared/Model/disply_items_model.dart';
import 'package:hotspot/feature/user/home/screen/rating%20and%20review/model/rating_review_model.dart';
import 'package:hotspot/feature/user/home/service/hotspots_display_service.dart';

class RatingNotifier extends StateNotifier<RatingState> {
  RatingNotifier() : super(RatingState());

  void updateRating(double newRating) {
    state = state.copyWith(rating: newRating);
  }

  void updateReview(String newReview) {
    state = state.copyWith(review: newReview);
  }

  Future<void> submitRating({
    required WidgetRef ref,
    required BuildContext context,
    required Hotspot hotspot,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.uid.isEmpty) {
      mySnackBar(message: "Please log in to rate", context: context);
      return;
    }
    state = state.copyWith(isLoading: true);
    bool success = false;
    try {
      final hotspotsRef = FirebaseFirestore.instance
          .collection("hotspot")
          .doc(hotspot.id);
      final docSnapshot = await hotspotsRef.get();
      if (!docSnapshot.exists) {
        throw Exception("Hotspot not found");
      }
      final data = docSnapshot.data()!;
      final currentReviews = (data["reviewCount"] as List? ?? [])
          .cast<Map<String, dynamic>>();

      final currentRating = (data["rating"] as num?)?.toDouble() ?? 0.0;

      final count = currentReviews.length;

      if (currentReviews.any((r) => r['userId'] == user.uid)) {
        mySnackBar(
          message: "You have already submitted a reviewed",
          context: context,
        );
        return;
      }

      currentReviews.add({
        'rating': state.rating,
        'review': state.review,
        'userId': user.uid,
        'timestamp': DateTime.now(),
      });

      final newAvg = (currentRating * count + state.rating) / (count + 1);

      await hotspotsRef.update({
        'rating': newAvg,
        'reviewCount': currentReviews,
      });

      final updatedHotspot = hotspot.copyWith(
        rating: newAvg,
        reviewCount: currentReviews,
      );

      ref.read(selectedMarkerProvider.notifier).state = updatedHotspot;
      Navigator.pop(context);
      success = true;
    } catch (e) {
      mySnackBar(message: "Error $e", context: context);
    } finally {
      state = state.copyWith(isLoading: false);
      if (success) {
        mySnackBar(
          message: "You have successfully added a review",
          context: context,
        );
      }
    }
  }

  void reset() {
    state = RatingState();
  }
}

final ratingNotifierProvider =
    StateNotifierProvider<RatingNotifier, RatingState>(
      (ref) => RatingNotifier(),
    );
