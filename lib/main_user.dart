import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hotspot/firebase_options.dart';
import 'package:hotspot/global.dart';
import 'package:hotspot/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Global.baseUrl = "User App";
  runApp(const MyApp());
}
