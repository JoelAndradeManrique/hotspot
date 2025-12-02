import 'package:flutter/material.dart';
import 'package:hotspot/feature/admin/home/screen/add_items_screen.dart';
import 'package:hotspot/feature/shared/service/google_auth_service.dart';
import 'package:hotspot/go_route.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Center(child: Text("Admin Home Screen")),
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
