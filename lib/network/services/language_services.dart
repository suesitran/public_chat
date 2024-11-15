import 'dart:convert';

import 'package:public_chat/_shared/data/country.dart';
import 'package:public_chat/_shared/data/language.dart';
import 'package:public_chat/network/apis/language_api.dart';

final class LanguageServices {
  LanguageServices._();

  static Future<List<Language>> fetchLanguages() async {
    final response = await LanguageApi.fetchLanguages();

    if (response != null && response.statusCode == 200) {
      final result = <String, Language>{};

      final List countriesData = jsonDecode(response.body);

      for (final countryJson in countriesData) {
        final country = Country.fromRestCountries(countryJson);
        final languages = (countryJson['languages'] as Map?)?.entries.map((e) {
              final String code = e.key;
              return Language.fromMapping(
                  code: code.length > 2 ? code.substring(0, 2) : code,
                  name: e.value);
            }) ??
            {};

        for (final language in languages) {
          result[language.code] =
              (result[language.code] ?? language).copyWith(countries: [
            ...(result[language.code]?.countries ?? []),
            country,
          ]);
        }
      }

      return result.values.toList();
    } else {
      throw Exception('Failed to load languages: ${response?.body}');
    }
  }
}
