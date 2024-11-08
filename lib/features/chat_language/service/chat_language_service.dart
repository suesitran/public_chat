import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';

class ChatLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String countryCode;

  ChatLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.countryCode,
  });

  factory ChatLanguage.fromJson(Map<String, dynamic> json) {
    return ChatLanguage(
      code: json["code"],
      name: json["name"],
      nativeName: json["nativeName"],
      countryCode: json["countryCode"],
    );
  }
}

class ChatLanguageService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<List<ChatLanguage>> getSupportedLanguages() async {
    try {
      final result =
          await _functions.httpsCallable('getSupportedLanguages').call();
      final List<dynamic> json = jsonDecode(jsonEncode(result.data));
      return json.map((e) => ChatLanguage.fromJson(e)).toList();
    } catch (e) {
      print('Error getting supported languages: $e');
      rethrow;
    }
  }
}
