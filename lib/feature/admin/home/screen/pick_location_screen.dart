import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  GoogleMapController? controller;
  LatLng _selectedLocation = const LatLng(
    20.9674,
    -89.5926,
  ); // Default to San Francisco
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              controller = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location;
              });
            },
            markers: {
              Marker(
                markerId: MarkerId('selected-location'),
                position: _selectedLocation,
              ),
            },
          ),
          Positioned(
            top: 60,
            child: MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
              shape: CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.arrow_back_ios_new),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 120,
            left: 120,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                Navigator.pop(context, _selectedLocation);
              },
              label: Text(
                "Set Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
