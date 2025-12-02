import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/core/provider/load_marker_provider.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/feature/admin/home/screen/add_items_screen.dart';
import 'package:hotspot/feature/admin/home/service/display_item_service.dart';
import 'package:hotspot/feature/shared/service/google_auth_service.dart';
import 'package:hotspot/go_route.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch the adminHotspot provider to get the list of HotSpot
    final hotspostAsync = ref.watch(adminHotSpots);
    //watch the markerIconsProvider to get custom marker icons for google maps
    final markerIconAsync = ref.watch(markerIconsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.white,
        title: Text("Admin Home"),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.add_chart)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              child: Icon(Icons.supervised_user_circle_outlined, size: 30),
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseServices().singOutUser();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      //body displays hotspots using the adminHotspots provider
      body: hotspostAsync.when(
        data: (hotspots) {
          if (hotspots.isEmpty) {
            return Center(child: Text("No hotspots added yet."));
          }
          //build a listview of hotspot
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: hotspots.length,
            itemBuilder: (context, index) {
              final hotspot = hotspots[index];
              return GestureDetector(
                //each hotspot is a card with details and a map
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 0.1,
                  shadowColor: Colors.green.shade100,
                  child: SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        //left side 60% of card for hotspot
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //display hotspot name
                                Text(
                                  hotspot.locationName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    //adjust front size based on name length
                                    fontSize: hotspot.locationName.length <= 32
                                        ? 18
                                        : 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                //display hotspot condition
                                Text("Condition: ${hotspot.condition}"),
                                //display fish type (category).
                                Text("Fish Type: ${hotspot.category}"),
                                //display rating
                                Text(
                                  "Rating: ${hotspot.rating.toStringAsFixed(1)}",
                                ),
                                //display time since hotspot was uploaded.
                                Text(
                                  "Uploaded: ${formatTimeAgo(hotspot.createdAt)}",
                                ),
                                //display the review count
                                GestureDetector(
                                  onTap: () {
                                    //navigate to the reviews screen
                                  },
                                  child: Text(
                                    "Reviews: ${hotspot.reviewCount.length}",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //right side 40% of card for a small google map with custom icon
                        Expanded(
                          flex: 4,
                          child: markerIconAsync.when(
                            //when marker icons are available
                            data: (markerIcons) => GoogleMap(
                              myLocationButtonEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  hotspot.latitude,
                                  hotspot.longitude,
                                ),
                                zoom: 15,
                              ),
                              //display a singlemarker for the hotspot
                              markers: {
                                Marker(
                                  markerId: MarkerId(hotspot.id),
                                  position: LatLng(
                                    hotspot.latitude,
                                    hotspot.longitude,
                                  ),
                                  //use custom icon based on condition, fallback to default
                                  icon:
                                      markerIcons[hotspot.condition] ??
                                      BitmapDescriptor.defaultMarker,
                                ),
                              },
                              liteModeEnabled: true,
                            ),
                            error: (error, _) =>
                                Center(child: Text("Error $error")),
                            loading: () =>
                                Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, _) => Center(child: Text("Error $error")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        onPressed: () {
          NavigationHelper.push(context, AddItemsScreen());
        },
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
