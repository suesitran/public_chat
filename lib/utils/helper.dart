import 'package:public_chat/l10n/text_ui_static.dart';
import 'package:public_chat/service_locator/service_locator.dart';

import 'constants.dart';

class Helper {
  static String getLanguageCodeByCountryCode(String countryCode) {
    return Constants.countries
        .firstWhere((el) => el['country_code'] == countryCode)['language_code'];
  }

  static String getTextTranslated(
    String key,
    String currentLanguageCode, {
    String? previousLanguageCode,
  }) {
    final textsUIStatic = ServiceLocator.instance.get<TextsUIStatic>().texts;
    return textsUIStatic[key]![currentLanguageCode] ??
        (textsUIStatic[key]![previousLanguageCode] ??
            textsUIStatic[key]!['en']!);
  }
}
