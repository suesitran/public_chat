import 'dart:convert';

class ChatLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String countryCode;

  String get imageUrl => 'https://flagcdn.com/${countryCode.toLowerCase()}.svg';

  ChatLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.countryCode,
  });

  factory ChatLanguage.defaultLanguage() {
    return ChatLanguage(
      code: "en",
      name: "English",
      nativeName: "English",
      countryCode: "US",
    );
  }

  factory ChatLanguage.fromJson(Map<String, dynamic> json) {
    return ChatLanguage(
      code: json["code"],
      name: json["name"],
      nativeName: json["nativeName"],
      countryCode: json["countryCode"],
    );
  }

  String toJsonString() {
    return jsonEncode({
      "code": code,
      "name": name,
      "nativeName": nativeName,
      "countryCode": countryCode,
    });
  }
}
