import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/l10n/text_ui_static.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import 'language_load_state.dart';

class LanguageLoadCubit extends Cubit<LanguageLoadState> {
  LanguageLoadCubit() : super(LanguageLoadInitial());

  List<String> _getListTextLanguageDefault(
    Map<String, Map<String, String>> listText,
  ) {
    List<String> listTextTranslate = [];
    for (var text in listText.values) {
      listTextTranslate.add(text['en']!);
    }
    return listTextTranslate;
  }

  Future<List<String>?> _translateText(
    String languageCode,
    List<String> listTextLanguageDefault,
  ) async {
    final translator = ServiceLocator.instance.get<GoogleTranslator>();
    try {
      print(DateTime.now().toString());
      Translation translation = await translator.translate(
        listTextLanguageDefault.join(Constants.textSplitListTextTranslate),
        from: 'en',
        to: languageCode,
      );
      print(DateTime.now().toString());
      return translation.text.split(Constants.textSplitListTextTranslate);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, Map<String, String>>> _matchListTextTranslated(
    String languageCode,
    Map<String, Map<String, String>> listTextStatic,
  ) async {
    List<String>? listTextTranslated = await _translateText(
      languageCode,
      _getListTextLanguageDefault(listTextStatic),
    );
    if (listTextTranslated != null &&
        listTextTranslated.length == listTextStatic.keys.length) {
      Map<String, Map<String, String>> listTextConverted = listTextStatic;
      for (int i = 0; i < listTextStatic.keys.length; i++) {
        String key = listTextStatic.keys.toList()[i];
        listTextConverted[key]![languageCode] = listTextTranslated[i];
      }
      return listTextConverted;
    } else {
      return listTextStatic;
    }
  }

  // Check has country code in local and != "US" => translate by language code
  // Opposite use text with country code device
  // country code device == null => use language code == default
  Future<void> loadAllLanguageStatic(String? countryCodeDevice) async {
    emit(LanguageLoadInProgress());
    // Order of priority : local > device > ''
    String currentCountryCode = ServiceLocator.instance
            .get<SharedPreferences>()
            .get(Constants.prefCurrentCountryCode)
            ?.toString() ??
        (countryCodeDevice ?? '');

    if (currentCountryCode.isNotEmpty &&
        currentCountryCode.toUpperCase() != 'US') {
      final textsUIStatic = ServiceLocator.instance.get<TextsUIStatic>();
      // Get language code from list country
      String currentLanguageCode = Constants.countries.firstWhere(
          (el) => el['country_code'] == currentCountryCode)['language_code'];

      Map<String, Map<String, String>> textsTranslated =
          await _matchListTextTranslated(
        currentLanguageCode,
        textsUIStatic.texts,
      );

      textsUIStatic.setTexts = textsTranslated;
    }
    emit(LanguageLoadSuccess(countryCodeSelected: currentCountryCode));
  }
}
