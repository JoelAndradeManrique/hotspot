import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

Future<Map<String, BitmapDescriptor>> loadCustomMarkers() async {
  try {
    return {
      "hotspot": await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(48, 48)),
        "../assets/marker/fish3.png",
      ),
      "Increasing": await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(48, 48)),
        "../assets/marker/fish1.png",
      ),
      "Decreasing": await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(48, 48)),
        "../assets/marker/fish4.png",
      ),
      "hotspot": await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(48, 48)),
        "../assets/marker/fish2.png",
      ),
    };
  } catch (e) {
    print("Error loading markers: $e");
    return {};
  }
}
