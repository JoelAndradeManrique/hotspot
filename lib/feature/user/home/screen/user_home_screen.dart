import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/core/provider/load_marker_provider.dart';
import 'package:hotspot/feature/user/home/screen/custom_info_window.dart';
import 'package:hotspot/feature/user/home/service/hotspots_display_service.dart';
import 'package:hotspot/feature/user/home/widget/filter_dialog_box.dart';

class UserHomeScreen extends ConsumerWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotspotAsync = ref.watch(hotspotsProvider);
    final markerIconsAsync = ref.watch(markerIconsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedMarker = ref.watch(selectedMarkerProvider);
    final fishCategoriesAsync = ref.watch(fishCategoriesProvider);
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
                  zoom: 12,
                ),
                markers: filterHotspots.isNotEmpty
                    ? filterHotspots.map((hotspot) {
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
                          onTap: () {
                            ref.read(selectedMarkerProvider.notifier).state =
                                hotspot;
                          },
                        );
                      }).toSet()
                    : {},
                onTap: (LatLng position) {
                  ref.read(selectedMarkerProvider.notifier).state = null;
                },
              ),
              if (selectedMarker != null)
                CustomInfoWindow(
                  selectedMarker: selectedMarker,
                  markerIconsAsync: markerIconsAsync,
                ),
              if (selectedMarker != null)
                Positioned(
                  top: 364,
                  left: 183,
                  child: Transform(
                    transform: Matrix4.rotationZ(pi / 4),
                    alignment: FractionalOffset.center,
                    child: Container(
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              Positioned(
                top: 50,
                right: 10,
                child: MaterialButton(
                  elevation: 0.3,
                  height: 50,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onPressed: () {
                    showFilterDialog(context, ref, fishCategoriesAsync);
                  },
                  child: Row(
                    children: [
                      Text(
                        selectedCategory ?? "Filter by Fish Type",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 5),
                      if (selectedCategory != null) ...[
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 13,
                          child: Text(
                            "${filterHotspots.length}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
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
