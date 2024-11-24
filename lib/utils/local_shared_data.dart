import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const keyCurrentSelectedLanguages = 'current_selected_languages';
String deviceLocale = kIsWeb ? 'english' : Platform.localeName;
String defaultLanguageCode = 'en';

class LocalSharedData {
  LocalSharedData._internal();
  static LocalSharedData instance = LocalSharedData._internal();
  factory LocalSharedData() {
    return instance;
  }

  late SharedPreferences sharedPreferences;

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  setCurrentSelectedLanguages(List<String> languages) async {
    await sharedPreferences.setStringList(
        keyCurrentSelectedLanguages, languages);
  }

  List<String> getCurrentSelectedLanguages() {
    return sharedPreferences.getStringList(keyCurrentSelectedLanguages) ??
        [deviceLocale, defaultLanguageCode];
  }
}
