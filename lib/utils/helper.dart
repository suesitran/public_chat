import 'constants.dart';

class Helper {
  static String getLanguageCodeByCountryCode(String countryCode) {
    return Constants.countries
        .firstWhere((el) => el['country_code'] == countryCode)['language_code'];
  }
}
