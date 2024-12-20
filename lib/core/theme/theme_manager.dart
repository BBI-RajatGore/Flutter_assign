import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  
  final SharedPreferences sharedPreferences;

  ThemeManager({required this.sharedPreferences});

  static const String _themeKey = 'theme';

  Future<void> saveTheme(bool isDarkMode) async {
    await sharedPreferences.setBool(_themeKey, isDarkMode);
  }

  Future<bool> getTheme() async {
    return sharedPreferences.getBool(_themeKey) ?? false; 
  }
}
