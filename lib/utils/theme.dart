import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {

  static const String _keyTheme = 'theme';

  static Future<void> saveTheme(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyTheme, isDarkMode);
  }


  static Future<bool> getSavedTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTheme) ?? false;
  }

}
