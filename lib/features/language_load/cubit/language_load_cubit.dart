import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/l10n/language_static.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

enum LanguageLoadState { initial, inProgress, success, failure }

class LanguageLoadCubit extends Cubit<LanguageLoadState> {
  LanguageLoadCubit() : super(LanguageLoadState.initial);

  Future<Map<String, Map<String, String>>> _translateAllLanguageStatic(
    String currentLanguageCode,
    Map<String, Map<String, String>> allLanguageStatic,
  ) async {
    final translator = ServiceLocator.instance.get<GoogleTranslator>();

    Map<String, Map<String, String>> allLanguageTranslated = {};

    await Future.forEach(allLanguageStatic.keys, (key) async {
      if (!allLanguageStatic[key]!.keys.contains(currentLanguageCode)) {
        try {
          Translation messageTranslated = await translator.translate(
            allLanguageStatic[key]![Constants.languageCodeDefault]!,
            from: Constants.languageCodeDefault,
            to: currentLanguageCode,
          );
          allLanguageTranslated[key]![currentLanguageCode] =
              messageTranslated.text;
        } catch (e) {
          null;
        }
      }
    });
    return allLanguageTranslated;
  }

  // Check has country code in local and != "US" => translate by language code
  // Opposite use text with language code "en" and navigate to another screen
  Future<void> loadAllLanguageStatic() async {
    emit(LanguageLoadState.inProgress);
    String currentCountryCode = ServiceLocator.instance
            .get<SharedPreferences>()
            .get(Constants.prefCurrentCountryCode)
            ?.toString() ??
        '';
    if (currentCountryCode.isNotEmpty &&
        currentCountryCode.toUpperCase() != Constants.countryCodeDefault) {
      final languageStatic = ServiceLocator.instance.get<LanguageStatic>();

      String currentLanguageCode = Constants.countries.firstWhere(
          (el) => el['country_code'] == currentCountryCode)['language_code'];

      Map<String, Map<String, String>> allLanguageTranslated =
          await _translateAllLanguageStatic(
        currentLanguageCode,
        languageStatic.languages,
      );

      languageStatic.updateDataLanguages(allLanguageTranslated);
    }
    emit(LanguageLoadState.success);
  }
}
