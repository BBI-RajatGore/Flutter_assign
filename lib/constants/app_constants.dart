import 'package:flutter/material.dart';

class AppConstants {

  static const Color primaryColor = Colors.teal;
  static const Color secondaryColor = Colors.red;
  static const Color backgroundColor = Colors.white;


  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );


  static const SnackBarError = SnackBar(
    content: Text(
      'Something went wrong!',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
  );

  // TODO list colors
  static final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.yellow,
  ];

}
