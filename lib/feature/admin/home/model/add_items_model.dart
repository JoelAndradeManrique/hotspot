import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddItemsState {
  final String? selectedCategory;
  final List<String> categories;
  final String? selectedCondition;
  final List<String> conditions;
  final LatLng? selectedLocation;
  final double? rating;
  final List<Map<String, dynamic>> reviewCount;

  AddItemsState({
    this.selectedCategory,
    this.categories = const [],
    this.selectedCondition,
    this.conditions = const ['hotspot', 'Decreasing', 'Little', 'Increasing'],
    this.selectedLocation,
    this.rating,
    this.reviewCount = const [],
  });

  AddItemsState copyWith({
    String? selectedCategory,
    List<String>? categories,
    String? selectedCondition,
    List<String>? conditions,
    LatLng? selectedLocation,
    double? rating,
    List<Map<String, dynamic>>? reviewCount,
  }) {
    return AddItemsState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      selectedCondition: selectedCondition ?? this.selectedCondition,
      conditions: conditions ?? this.conditions,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}
