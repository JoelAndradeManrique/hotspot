// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/core/common/widgets/my_button.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/feature/admin/home/screen/admin_home_screen.dart';
import 'package:hotspot/feature/admin/home/screen/pick_location_screen.dart';
import 'package:hotspot/feature/admin/home/service/add_items_service.dart';
import 'package:hotspot/feature/admin/home/widgets/show_add_category_dialog.dart';
import 'package:hotspot/go_route.dart';

class AddItemsScreen extends ConsumerWidget {
  AddItemsScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController newCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(additemProvider);
    final notifier = ref.read(additemProvider.notifier);

    _categoryController.text = state.selectedCondition ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add New Hotspot Location"),
        centerTitle: true,
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (state.selectedCondition == null) {
                    final LatLng? selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PickLocationScreen(),
                      ),
                    );
                    if (selectedLocation != null) {
                      notifier.setSelectedLocation(selectedLocation);
                    }
                  }
                },
                child: Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: state.selectedLocation == null
                      ? Icon(Icons.location_pin, size: 50)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: state.selectedLocation!,
                              zoom: 15,
                            ),
                            markers: {
                              // <--- AGREGA ESTO para que se vea el pin rojo en el mapa chiquito
                              Marker(
                                markerId: MarkerId('selected-location'),
                                position: state.selectedLocation!,
                                draggable: true,
                                //update location if marker is dragged
                                onDragEnd: (LatLng newPosition) {
                                  notifier.setSelectedLocation(newPosition);
                                },
                              ),
                            },
                            liteModeEnabled: false,

                            onTap: (LatLng position) {
                              // Do nothing on tap in lite mode
                              notifier.setSelectedLocation(position);
                            },
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Location Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            //dropdown for selecting condition(eg, hotspot, Decreasing, Little, Increasing)
            DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              value: state.selectedCondition,
              decoration: InputDecoration(
                labelText: "Select Condition",
                border: OutlineInputBorder(),
              ),
              items: state.conditions.map((String condition) {
                return DropdownMenuItem(
                  value: condition,
                  child: Text(condition),
                );
              }).toList(),
              onChanged: notifier.setSelectedCondition,
            ),
            SizedBox(height: 10),

            //dropdown for selecting a category or adding a new one
            DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              value: state.selectedCategory,
              decoration: InputDecoration(
                labelText: "Select Category",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value == "Add Category") {
                  //show dialog to add a new category
                  showAddCategoryDialog(context, ref, newCategoryController);
                } else {
                  notifier.setSelectedCategory(value);
                  _categoryController.text = value ?? '';
                }
              },
              items: [
                //list of existing categories available on firebase category collection
                ...state.categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }),
                //option to add a new category
                const DropdownMenuItem<String>(
                  value: "Add Category",
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "Add Category",
                        style: TextStyle(color: Colors.green, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // read-only field for ration (default 0.0)
            TextField(
              readOnly: true,
              controller: TextEditingController(text: "0.0"),
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                labelText: "Rating",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // read-only field for review (default 0.0)
            TextField(
              readOnly: true,
              controller: TextEditingController(text: "0.0"),
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                labelText: "Review",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            //button to save the item
            MyButton(
              onTab: () async {
                //save the item to firebase
                try {
                  await notifier.saveItems(
                    locationName: _nameController.text,
                    context: context,
                  );
                  //show the success message if success
                  mySnackBar(
                    message: "Item saved successfully",
                    context: context,
                  );
                  //clear the inpute fields
                  _categoryController.clear();
                  _nameController.clear();
                  // Navigate back to the admin home screen
                  NavigationHelper.pushReplacement(context, AdminHomeScreen());
                } catch (e) {
                  //show error message if saving fails
                  mySnackBar(message: "Error $e", context: context);
                }
              },
              buttonText: "Save",
            ),
          ],
        ),
      ),
    );
  }
}
