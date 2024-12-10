import 'package:flutter/material.dart';

class AppConstants {

  static const TextStyle titleTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 16,
  );

  static const TextStyle errorTextStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );


  static const Color lightBackgroundColor = Colors.white;
  static const Color darkBackgroundColor = Colors.black;
  static const Color lightTextColor = Colors.black;
  static const Color darkTextColor = Colors.white;
  static const Color lightAppBarColor = Colors.orange;
  static const Color darkAppBarColor = Colors.purple;
  static const Color lightCardColor = Colors.white;
  static const Color darkCardColor = Color.fromARGB(255, 59, 50, 50);
  static const Color lightBorderColor = Colors.orange;
  static const Color darkBorderColor = Colors.grey;


  static const Color iconColor = Colors.white;


  static const String noPostsAvailableText = 'No Posts Available.';
  static const String unexpectedErrorText = 'Unexpected Error';

}
