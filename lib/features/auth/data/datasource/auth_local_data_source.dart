import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/utils/shared_preference_filter.dart';

class SharedPreferencesHelper {
  final SharedPreferences sharedPreferences;

  SharedPreferencesHelper({required this.sharedPreferences});

  final String _userIdKey = 'userId';

  Future<void> saveUserId(String userId) async {
    await sharedPreferences.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    return sharedPreferences.getString(_userIdKey);
  }

  Future<void> removeUserId() async {
    // to clear the filter 
   await FilterPreferences.clearFilterPreferences();

    await sharedPreferences.remove(_userIdKey);
  }
}
