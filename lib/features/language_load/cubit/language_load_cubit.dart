import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/l10n/language_static.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

enum LanguageLoadState { initial, inProgress, success, failure }

class LanguageLoadCubit extends Cubit<LanguageLoadState> {
  LanguageLoadCubit() : super(LanguageLoadState.initial);

  Future<void> loadAllLanguageStatic() async {
    emit(LanguageLoadState.inProgress);
    final allLanguage = ServiceLocator.instance.get<LanguageStatic>().languages;
    Map<String, Map<String, String>> allLanguageTranslated = {};
    if (allLanguage.keys.isNotEmpty) {
      String currentCountryCode = ServiceLocator.instance
              .get<SharedPreferences>()
              .get(Constants.prefCurrentCountryCode)
              ?.toString() ??
          '';
      if (currentCountryCode.isEmpty) {
        currentCountryCode =
            WidgetsBinding.instance.platformDispatcher.locale.countryCode ??
                Constants.countryCodeDefault;
      }
      String currentLanguageCode = Constants.countries.firstWhere(
          (el) => el['country_code'] == currentCountryCode)['language_code'];
      final translator = ServiceLocator.instance.get<GoogleTranslator>();
      await Future.forEach(allLanguage.keys, (key) async {
        if (!allLanguage[key]!.keys.contains(currentLanguageCode)) {
          Translation messageTranslated = await translator.translate(
            allLanguage[key]![Constants.languageCodeDefault]!,
            from: Constants.languageCodeDefault,
            to: currentLanguageCode,
          );
          allLanguageTranslated[key]![currentLanguageCode] =
              messageTranslated.text;
        }
      });
    }
  }
}
