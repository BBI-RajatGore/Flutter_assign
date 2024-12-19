import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _themeKey = 'theme';


  Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, isDarkMode);
  }


  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; 
  }
  
}
