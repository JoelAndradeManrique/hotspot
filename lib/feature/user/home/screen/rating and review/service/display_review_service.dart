import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      hotspotsId,
    ) {
      return FirebaseFirestore.instance
          .collection("hotspot")
          .doc(hotspotsId)
          .snapshots()
          .map((snapshot) {
            final rawList = snapshot.data()?['reviewCount'];
            if (rawList is! List) return [];
            final reviews = rawList.cast<Map<String, dynamic>>();

            reviews.sort((a, b) {
              final aTime = (a['timestamp'] as Timestamp?)?.toDate();
              final bTime = (b['timestamp'] as Timestamp?)?.toDate();
              return bTime?.compareTo(aTime ?? DateTime(0)) ?? 0;
            });
            return reviews;
          });
    });
