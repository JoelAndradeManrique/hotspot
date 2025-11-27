import 'package:flutter/material.dart';

mySnackBar({
  required String message,
  required BuildContext context,
  Color color = Colors.blue,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      duration: Duration(milliseconds: 1500),
      content: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
