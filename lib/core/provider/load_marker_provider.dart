import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/core/utils/marker_utils.dart';

final markerIconsProvider = FutureProvider<Map<String, BitmapDescriptor>>((
  ref,
) async {
  return await loadCustomMarkers();
});
