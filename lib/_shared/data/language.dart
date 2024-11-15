import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:public_chat/_shared/data/country.dart';
import 'package:public_chat/network/apis/language_api.dart';

final class Language extends Equatable {
  final String code;
  final String name;
  final String? navigateName;
  final List<Country> countries;

  static const _mappingLanguages = {
    'vi': Language(
        code: 'vi',
        name: 'Vietnamese',
        navigateName: 'Tiếng Việt',
        countries: [
          Country(name: 'Việt Nam', code: 'vn'),
        ]),
    'en': Language(
      code: 'en',
      name: 'English',
      navigateName: 'English',
      countries: [
        Country(
          name: 'United States',
          code: 'us',
        )
      ],
    ),
  };

  const Language({
    required this.code,
    required this.name,
    required this.navigateName,
    required this.countries,
  });

  Language copyWith({List<Country>? countries}) => Language(
      code: code,
      name: name,
      navigateName: navigateName,
      countries: countries ?? this.countries);

  factory Language.fromMapping({
    required String code,
    String? name,
    String? navigateName,
    List<Country>? countries,
  }) {
    final mappingLanguage = _mappingLanguages[code];

    return Language(
      code: code,
      name: name ?? mappingLanguage?.name ?? 'N/A',
      navigateName: navigateName ?? mappingLanguage?.navigateName,
      countries: countries ?? mappingLanguage?.countries ?? [],
    );
  }

  String get showName => navigateName ?? name;

  factory Language.fromMap(Map data) {
    final countriesData = data['countries'];

    return Language(
      code: data['code'],
      name: data['name'],
      navigateName: data['navigateName'],
      countries: countriesData is List<Map>
          ? countriesData.map((e) => Country.fromMap(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap({bool importCountry = true}) => {
        'code': code,
        'name': name,
        if (navigateName != null) 'navigateName': navigateName,
        if (importCountry && countries.isNotEmpty)
          'countries': countries.map((e) => e.toMap()).toList(),
      };

  Locale get locale => Locale(code, countries.firstOrNull?.code);

  String get flagUrl =>
      LanguageApi.getLocaleFlagUrl(locale.countryCode ?? locale.languageCode);

  @override
  List<Object?> get props => [code, name, navigateName, countries];
}
