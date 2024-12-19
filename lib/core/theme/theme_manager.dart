// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeManager {
//   static const String _themeKey = 'theme';


//   static Future<void> saveTheme(bool isDarkMode) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool(_themeKey, isDarkMode);
//   }

//   static Future<bool> loadTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_themeKey) ?? false; 
//   }
  
// }


import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _themeKey = 'theme';

  // Method to save the theme
  Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, isDarkMode);
  }

  // Method to load the saved theme
  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // Default to light theme
  }
  
}
