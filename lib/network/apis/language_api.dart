import 'package:http/http.dart' as http;

final class LanguageApi {
  LanguageApi._();

  static Future<http.Response?> fetchLanguages() {
    final url = Uri.parse('https://restcountries.com/v3.1/all');

    return http.get(url);
  }

  static String getLocaleFlagUrl(String countryCode) {
    return 'https://flagcdn.com/24x18/${countryCode.toLowerCase()}.png';
  }
}
