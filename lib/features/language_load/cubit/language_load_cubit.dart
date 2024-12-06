import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/l10n/text_ui_static.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/app_extensions.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:public_chat/utils/helper.dart';
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
    List<String> listTextTranslated = [];
    try {
      await Future.forEach(listTextLanguageDefault, (text) async {
        Translation translation = await translator.translate(
          text,
          from: 'en',
          to: languageCode,
        );
        listTextTranslated.add(translation.text);
      });
      return listTextTranslated;
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
    if (listTextTranslated.isNotNullAndNotEmpty) {
      Map<String, Map<String, String>> listTextConverted = listTextStatic;
      for (int i = 0; i < listTextStatic.keys.length; i++) {
        String key = listTextStatic.keys.toList()[i];
        listTextConverted[key]![languageCode] =
            i <= listTextTranslated!.length - 1
                ? listTextTranslated[i]
                : listTextConverted[key]!['en']!;
      }
      return listTextConverted;
    }
    return listTextStatic;
  }

  FutureOr<void> _translateAllTextStatic(
    String currentCountryCode,
    String currentLanguageCode,
  ) async {
    if (currentCountryCode.isNotEmpty &&
        currentCountryCode.toUpperCase() != 'US') {
      final textsUIStatic = ServiceLocator.instance.get<TextsUIStatic>();

      // Check no has language code in value text static => translate
      if (!textsUIStatic.texts.values.first.keys
          .contains(currentLanguageCode)) {
        Map<String, Map<String, String>> textsTranslated =
            await _matchListTextTranslated(
          currentLanguageCode,
          textsUIStatic.texts,
        );
        textsUIStatic.setTexts = textsTranslated;
      }
    }
  }

  Future<void> _translateAllChatMessage(String currentLanguageCode) async {
    await ServiceLocator.instance
        .get<Database>()
        .translateMessageByCurrentLanguageCode(currentLanguageCode);
  }

  // Check has country code in local and != "US" => translate by language code
  // Opposite use text with country code device
  // country code device == null => use language code == default
  Future<void> translateAllTextStaticAndChatMessage(
      String? countryCodeDevice) async {
    emit(LanguageLoadInProgress());
    // Order of priority : local > device > ''
    String currentCountryCode = ServiceLocator.instance
            .get<SharedPreferences>()
            .get(Constants.prefCurrentCountryCode)
            ?.toString() ??
        (countryCodeDevice ?? '');
    String currentLanguageCode =
        Helper.getLanguageCodeByCountryCode(currentCountryCode);

    await _translateAllTextStatic(currentCountryCode, currentLanguageCode);
    await _translateAllChatMessage(currentLanguageCode);

    emit(
      LanguageLoadSuccess(
        countryCodeSelected: currentCountryCode,
        languageCodeSelected: currentLanguageCode,
      ),
    );
  }
}
