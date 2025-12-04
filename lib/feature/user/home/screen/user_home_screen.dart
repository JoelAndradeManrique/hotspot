import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/feature/user/home/service/hotspots_display_service.dart';

class UserHomeScreen extends ConsumerWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotspotAsync = ref.watch(hotspotsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    return Scaffold(
      body: hotspotAsync.when(
        data: (hotspots) {
          if (hotspots.isEmpty) {
            return Center(child: Text("No Hotspots available"));
          }
          final filterHotspots = selectedCategory == null
              ? hotspots
              : hotspots
                    .where((hotspot) => hotspot.category == selectedCategory)
                    .toList();
          return Stack(
            children: [
              //google map
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: filterHotspots.isNotEmpty
                      ? LatLng(
                          filterHotspots[0].latitude,
                          filterHotspots[0].longitude,
                        )
                      : LatLng(28.3949, 84.1240),
                  zoom: 7,
                ),
              ),
            ],
          );
        },
        error: (error, _) => Center(child: Text("Error $error")),
        loading: () => CircularProgressIndicator(),
      ),
    );
  }
}
