class LanguageEntity {
  String? langCode;
  String? langEnglishName;
  String? langNativeName;

  LanguageEntity({this.langCode, this.langEnglishName, this.langNativeName});

  LanguageEntity.fromJson(Map<String, dynamic> json) {
    langCode = json['langCode'];
    langEnglishName = json['langEnglishName'];
    langNativeName = json['langNativeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['langCode'] = langCode;
    data['langEnglishName'] = langEnglishName;
    data['langNativeName'] = langNativeName;
    return data;
  }
}
