import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/translate_message.dart/ui/translate_settings_button.dart';

const keyIsFirstOpenKey = 'is_first_open';
const keyUser = 'user';
const keyCurrentSelectedLanguages = 'current_selected_languages';

String deviceLocale = Platform.localeName;
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
    bool isFirstOpen = sharedPreferences.getBool(keyIsFirstOpenKey) ?? true;
    if (isFirstOpen) {
      showSelectLang();
    }
  }

  Future<bool> saveIsFirstOpen() async {
    return sharedPreferences.setBool(keyIsFirstOpenKey, false);
  }

  setCurrentSelectedLanguages(List<String> languages) async {
    List<String>? localList =
        sharedPreferences.getStringList(keyCurrentSelectedLanguages);
    if (localList != null) {
      for (var local in localList) {
        for (var language in languages) {
          if (local.toLowerCase() == language.toLowerCase()) {
            return; //already exist
          } else {
            languages.add(local);
          }
        }
      }
    }
    await sharedPreferences.setStringList(
        keyCurrentSelectedLanguages, languages);
  }

  List<String> getCurrentSelectedLanguages() {
    return sharedPreferences.getStringList(keyCurrentSelectedLanguages) ??
        [deviceLocale];
  }
}
