import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:public_chat/models/entities/language_entity.dart';

class RemoteConfigHelper {
  static RemoteConfigHelper? _instance;

  RemoteConfigHelper._();

  static RemoteConfigHelper get instance {
    _instance ??= RemoteConfigHelper._();
    return _instance!;
  }

  final _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    _remoteConfig.fetchAndActivate();
  }

  Future<List<LanguageEntity>> getSupportedLanguages() async {
    final supportedLanguages =
        _remoteConfig.getValue('supported_languages').asString();
    if (supportedLanguages.isEmpty) {
      return [];
    }
    List<Map<String, dynamic>> languages = List<Map<String, dynamic>>.from(
        json.decode(supportedLanguages) as List<dynamic>);
    return languages.map((e) => LanguageEntity.fromJson(e)).toList();
  }
}
