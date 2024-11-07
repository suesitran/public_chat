const Map<String, Map<String, String>> kLocaleData = {
  'en': {'country': 'GB', 'name': 'English'},
  'es': {'country': 'ES', 'name': 'Español'},
  'fr': {'country': 'FR', 'name': 'Français'},
  'de': {'country': 'DE', 'name': 'Deutsch'},
  'it': {'country': 'IT', 'name': 'Italiano'},
  'pt': {'country': 'PT', 'name': 'Português'},
  'ru': {'country': 'RU', 'name': 'Русский'},
  'ja': {'country': 'JP', 'name': '日本語'},
  'ko': {'country': 'KR', 'name': '한국어'},
  'zh': {'country': 'CN', 'name': '中文'},
  'ar': {'country': 'SA', 'name': 'العربية'},
  'hi': {'country': 'IN', 'name': 'हिन्दी'},
  'bn': {'country': 'BD', 'name': 'বাংলা'},
  'nl': {'country': 'NL', 'name': 'Nederlands'},
  'pl': {'country': 'PL', 'name': 'Polski'},
  'tr': {'country': 'TR', 'name': 'Türkçe'},
  'vi': {'country': 'VN', 'name': 'Tiếng Việt'},
  'th': {'country': 'TH', 'name': 'ไทย'},
  'sv': {'country': 'SE', 'name': 'Svenska'},
  'da': {'country': 'DK', 'name': 'Dansk'},
  'fi': {'country': 'FI', 'name': 'Suomi'},
  'no': {'country': 'NO', 'name': 'Norsk'},
  'cs': {'country': 'CZ', 'name': 'Čeština'},
  'el': {'country': 'GR', 'name': 'Ελληνικά'},
  'he': {'country': 'IL', 'name': 'עברית'},
  'ro': {'country': 'RO', 'name': 'Română'},
  'uk': {'country': 'UA', 'name': 'Українська'},
  'id': {'country': 'ID', 'name': 'Bahasa Indonesia'},
  'ms': {'country': 'MY', 'name': 'Bahasa Melayu'},
  'fa': {'country': 'IR', 'name': 'فارسی'},
  'hu': {'country': 'HU', 'name': 'Magyar'},
  'sk': {'country': 'SK', 'name': 'Slovenčina'},
  'bg': {'country': 'BG', 'name': 'Български'},
  'hr': {'country': 'HR', 'name': 'Hrvatski'},
  'sr': {'country': 'RS', 'name': 'Српски'},
  'sl': {'country': 'SI', 'name': 'Slovenščina'},
  'et': {'country': 'EE', 'name': 'Eesti'},
  'lv': {'country': 'LV', 'name': 'Latviešu'},
  'lt': {'country': 'LT', 'name': 'Lietuvių'},
};

class LocaleInfo {
  final String code;
  final String name;
  final String emoji;
  final String imageUrl;

  LocaleInfo({
    required this.code,
    required this.name,
    required this.emoji,
    required this.imageUrl,
  });

  static LocaleInfo from({required String languageCode}) {
    // Convert language code to lowercase for consistency
    final code = languageCode.toLowerCase();

    // Get the locale data from the mapping
    final data = kLocaleData[code];

    if (data == null) {
      throw UnimplementedError(
        'Warning: No data found for language code: $languageCode',
      );
    }

    final countryCode = data['country']!;

    return LocaleInfo(
      code: code,
      name: data['name']!,
      emoji: _countryCodeToFlagEmoji(countryCode),
      imageUrl: 'https://flagcdn.com/${countryCode.toLowerCase()}.svg',
    );
  }

  /// Converts a country code to a flag emoji
  static String _countryCodeToFlagEmoji(String countryCode) {
    const flagOffset = 0x1F1E6;
    const asciiOffset = 0x41;

    final firstChar = countryCode.codeUnitAt(0) - asciiOffset + flagOffset;
    final secondChar = countryCode.codeUnitAt(1) - asciiOffset + flagOffset;

    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }
}
