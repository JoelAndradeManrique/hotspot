import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hotspot/feature/user/home/screen/info_screen.dart';
import 'package:hotspot/feature/user/home/screen/profile_screen.dart';
import 'package:hotspot/feature/user/home/screen/user_home_screen.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});
  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int isSelected = 1;
  late final List<Widget> _screen;

  @override
  void initState() {
    _screen = [InfoScreen(), UserHomeScreen(), ProfileScreen()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green,
        color: Colors.blueAccent,

        //current selected tab index
        index: isSelected,
        items: [
          Icon(Icons.info, color: Colors.white, size: 30),
          Icon(Icons.area_chart_outlined, color: Colors.white, size: 30),
          Icon(Icons.person_outlined, color: Colors.white, size: 30),
        ],
        //update the selected tab when an icon is tapped
        onTap: (value) {
          setState(() {
            isSelected = value;
          });
        },
      ),
      //display the screen corresponding to the selected tab
      body: _screen[isSelected],
    );
  }
}
