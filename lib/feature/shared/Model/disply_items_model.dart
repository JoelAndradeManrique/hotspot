import 'package:cloud_firestore/cloud_firestore.dart';

class Hotspot {
  final String id;
  final String locationName;
  final String category;
  final String condition;
  final double latitude;
  final double longitude;
  final double rating;
  final List<Map<String, dynamic>> reviewCount;
  final DateTime createdAt;

  Hotspot({
    required this.id,
    required this.locationName,
    required this.category,
    required this.condition,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
  });

  Hotspot copyWith({
    double? rating,
    List<Map<String, dynamic>>? reviewCount,
    String? id,
    String? locationName,
    String? category,
    String? condition,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  }) {
    return Hotspot(
      id: id ?? this.id,
      locationName: locationName ?? this.locationName,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Hotspot.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception("Document data is null");
    }
    return Hotspot(
      id: doc.id,
      locationName: data['locationName'] as String? ?? 'N/A',
      category: data['category'] as String? ?? 'N/A',
      condition: data['condition'] as String? ?? 'N/A',

      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as List? ?? [])
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
