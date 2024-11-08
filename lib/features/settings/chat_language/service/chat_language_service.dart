import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:public_chat/features/settings/chat_language/data/chat_language.dart';

class ChatLanguageService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;

  static Future<List<ChatLanguage>> getSupportedLanguages() async {
    try {
      final result =
          await _functions.httpsCallable('getSupportedLanguages').call();
      final List<dynamic> json = jsonDecode(jsonEncode(result.data));
      return json.map((e) => ChatLanguage.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
