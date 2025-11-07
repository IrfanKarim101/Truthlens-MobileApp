import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class SharedPrefsHelper {
  final SharedPreferences _prefs;
  
  SharedPrefsHelper(this._prefs);
  
  // Keys
  static const String _userDataKey = 'user_data';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  
  // ==================== USER DATA ====================
  
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs.setString(_userDataKey, jsonEncode(userData));
  }
  
  Map<String, dynamic>? getUserData() {
    final data = _prefs.getString(_userDataKey);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }
  
  Future<void> clearUserData() async {
    await _prefs.remove(_userDataKey);
  }
  
  // ==================== ONBOARDING ====================
  
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingKey, completed);
  }
  
  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }
  
  // ==================== THEME ====================
  
  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeKey, mode);
  }
  
  String getThemeMode() {
    return _prefs.getString(_themeKey) ?? 'system';
  }
  
  // ==================== LANGUAGE ====================
  
  Future<void> setLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }
  
  String getLanguage() {
    return _prefs.getString(_languageKey) ?? 'en';
  }
  
  // ==================== CLEAR ALL ====================
  
  Future<void> clearAll() async {
    await _prefs.clear();
  }
  
  // ==================== GENERIC METHODS ====================
  
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  String? getString(String key) {
    return _prefs.getString(key);
  }
  
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }
  
  int? getInt(String key) {
    return _prefs.getInt(key);
  }
  
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
  
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
  
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
