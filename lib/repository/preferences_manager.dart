import 'dart:convert';

import 'package:public_chat/_shared/data/language_support_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static const String userLanguageKey = 'userLanguage';
  static const String appTextUiKey = 'appText';

  static PreferencesManager? _instance;

  PreferencesManager._();

  static PreferencesManager get instance {
    _instance ??= PreferencesManager._();
    return _instance!;
  }

  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userLanguageKey, language);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userLanguageKey) ?? defaultLanguage;
  }

  Future<void> saveAppText(Map<String, dynamic> appText) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(appText); // Convert the map to JSON string
    await prefs.setString(appTextUiKey, jsonString);
  }

  // Get a value from appText by key
  Future<String?> getAppText(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(appTextUiKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> appTextMap =
        jsonDecode(jsonString); // Decode JSON string back to Map

    return appTextMap[key] as String?;
  }

  // Get the entire appText map
  Future<Map<String, String>> getAllAppText() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(appTextUiKey);

    if (jsonString == null) return {};

    final Map<String, dynamic> appTextMap = jsonDecode(jsonString);
    return appTextMap.map((key, value) => MapEntry(key, value.toString()));
  }
}
