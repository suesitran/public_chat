import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

const keyIsFirstOpenKey = 'is_first_open';
const keyLoginModel = 'login_model';
const keyUser = 'user';
const keyChatLanguages = 'chat_languages'; //current languages
const keyListHistoryLanguages = 'list_history_languages';

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

  saveIsFirstOpen() async {
    sharedPreferences.setBool(keyIsFirstOpenKey, false);
  }

  List<String> listHistoryLanguages = [defaultLanguageCode, 'english'];
  setChatLanguagesAndHistoryLanguages(List<String> languages) async {
    await setChatLanguages(languages);
    await setListHistoryLanguages(languages);
  }

  setChatLanguages(List<String> languages) async {
    await sharedPreferences.setStringList(keyChatLanguages, languages);
  }

  setListHistoryLanguages(List<String> languages) async {
    for (var language in languages) {
      if (listHistoryLanguages.contains(language)) {
        return; //already exist
      } else {
        listHistoryLanguages.add(language);
        await sharedPreferences.setStringList(
            keyListHistoryLanguages, listHistoryLanguages);
      }
    }
  }

  List<String> getListHistoryLanguages() {
    List<String> list =
        sharedPreferences.getStringList(keyListHistoryLanguages) ??
            [defaultLanguageCode, 'en'];
    return list;
  }

  List<String>? getChatLanguages() {
    return sharedPreferences.getStringList(keyChatLanguages);
  }
}
