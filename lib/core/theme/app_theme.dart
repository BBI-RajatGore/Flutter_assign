import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme() {

    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.orange,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(color: Colors.white), 
        elevation: 4,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.orange, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5, 
          padding: const  EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {

    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black87, 
      appBarTheme: const  AppBarTheme(
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        iconTheme: IconThemeData(color: Colors.white), 
        elevation: 4,
      ),


      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          padding: const  EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          textStyle: const  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

    );
  }
}
