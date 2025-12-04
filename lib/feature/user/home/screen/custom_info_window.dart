import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/feature/shared/Model/disply_items_model.dart';
import 'package:hotspot/feature/user/home/screen/rating%20and%20review/screen/review_screen.dart';
import 'package:hotspot/feature/user/home/screen/rating%20and%20review/widgets/show_rating_dialog.dart';
import 'package:hotspot/feature/user/home/service/hotspots_display_service.dart';
import 'package:hotspot/go_route.dart';

class CustomInfoWindow extends ConsumerWidget {
  const CustomInfoWindow({
    super.key,
    required this.selectedMarker,
    required this.markerIconsAsync,
  });

  final Hotspot selectedMarker;
  final AsyncValue<Map<String, BitmapDescriptor>> markerIconsAsync;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 180,
      left: 15,
      right: 15,
      child: Material(
        elevation: 1,
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 11,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedMarker.locationName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Fish: ${selectedMarker.category}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                selectedMarker.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ShowRatingDialog(
                                        hotspot: selectedMarker,
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.star, color: Colors.orange),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  NavigationHelper.push(
                                    context,
                                    ReviewScreen(hotspotId: selectedMarker.id),
                                  );
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "(",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "${selectedMarker.reviewCount.length} Reviews",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextSpan(text: ")"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Condition: ${selectedMarker.condition}",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Added ${selectedMarker.createdAt}",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.bike_scooter, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                "Open",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: markerIconsAsync.when(
                      data: (markerIcons) => GoogleMap(
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            selectedMarker.latitude,
                            selectedMarker.longitude,
                          ),
                          zoom: 16,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(selectedMarker.id),
                            position: LatLng(
                              selectedMarker.latitude,
                              selectedMarker.longitude,
                            ),
                            icon:
                                markerIcons[selectedMarker.condition] ??
                                BitmapDescriptor.defaultMarker,
                          ),
                        },
                        liteModeEnabled: true,
                      ),
                      error: (error, _) =>
                          Center(child: Text("Error loading markers")),
                      loading: () => CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 3,
                top: 2,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(selectedMarkerProvider.notifier).state = null;
                    },
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
