import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  final SharedPreferences _prefs;
  
  SharedPrefsHelper(this._prefs);
  
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs.setString('user_data', jsonEncode(userData));
  }
  
  Future<Map<String, dynamic>?> getUserData() async {
    final data = _prefs.getString('user_data');
    return data != null ? jsonDecode(data) : null;
  }
  
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}