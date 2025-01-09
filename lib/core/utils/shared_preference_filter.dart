import 'package:shared_preferences/shared_preferences.dart';


class FilterPreferences {

  static const String _filterPriorityKey = 'filter_priority';
  static const String _filterIsDescKey = 'filter_is_desc';


  static Future<void> saveFilterPreferences(String? priority, bool? isDesc) async {
    final prefs = await SharedPreferences.getInstance();

    if (priority != null) {
      await  prefs.setString(_filterPriorityKey, priority);
    }
    if (isDesc != null) {
      await prefs.setBool(_filterIsDescKey, isDesc);
    }
  }

 
  static Future<String?> getFilterPriority() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_filterPriorityKey) ?? "all";
  }

  static Future<bool?> getFilterIsDesc() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_filterIsDescKey) ?? false;
  }

  static Future<void> clearFilterPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_filterPriorityKey);
    await prefs.remove(_filterIsDescKey);
  }

}
