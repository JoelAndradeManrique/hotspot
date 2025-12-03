import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/core/provider/load_marker_provider.dart';
import 'package:hotspot/feature/admin/home/service/display_item_service.dart';

class UserModeScreen extends ConsumerWidget {
  const UserModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotsspotAsync = ref.watch(adminHotSpots);
    final markerIconsAsync = ref.watch(markerIconsProvider);
    return Scaffold(
      appBar: AppBar(title: Text("User Mode")),
      body: hotsspotAsync.when(
        data: (hotspots) {
          if (hotspots.isEmpty) {
            return Center(child: Text("No hotspots added yet."));
          }
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(hotspots[0].latitude, hotspots[0].longitude),
              zoom: 18,
            ),
            markers: hotspots.map((hotspot) {
              return Marker(
                markerId: MarkerId(hotspot.id),
                position: LatLng(hotspot.latitude, hotspot.longitude),
                icon: markerIconsAsync.when(
                  data: (markerIcons) =>
                      markerIcons[hotspot.condition] ??
                      BitmapDescriptor.defaultMarker,
                  error: (_, __) => BitmapDescriptor.defaultMarker,
                  loading: () => BitmapDescriptor.defaultMarker,
                ),
              );
            }).toSet(),
          );
        },
        error: (error, _) => Center(child: Text("Error $error")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
