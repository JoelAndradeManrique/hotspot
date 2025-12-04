import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appInfoProvider = StreamProvider<List<AppInfo>>((ref) {
  return FirebaseFirestore.instance
      .collection("info")
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => AppInfo.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList(),
      );
});

class AppInfo {
  final String image;
  final String title;
  final String description;

  AppInfo({
    required this.image,
    required this.title,
    required this.description,
  });

  factory AppInfo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppInfo(
      image: data['image'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
