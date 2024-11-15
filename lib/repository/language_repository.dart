import 'package:flutter/material.dart';
import 'package:public_chat/models/entities/language_entity.dart';
import 'package:public_chat/repository/remote_config_helper.dart';

final class LanguageRepository {
  static LanguageRepository? _instance;
  List<LanguageEntity> _languages = [];

  LanguageRepository._();

  List<LanguageEntity> get languages => _languages;

  static LanguageRepository get instance {
    _instance ??= LanguageRepository._();
    return _instance!;
  }

  Future<void> getLanguages() async {
    try {
      _languages = await RemoteConfigHelper.instance.getSupportedLanguages();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
