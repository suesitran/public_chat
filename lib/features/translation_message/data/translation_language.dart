enum TranslationLanguage {
  english('en', 'English', '🇬🇧'),
  vietnamese('vi', 'Tiếng Việt', '🇻🇳'),
  japanese('ja', '日本語', '🇯🇵'),
  korean('ko', '한국어', '🇰🇷'),
  chinese('zh', '中文', '🇨🇳'),
  french('fr', 'Français', '🇫🇷'),
  german('de', 'Deutsch', '🇩🇪'),
  spanish('es', 'Español', '🇪🇸'),
  italian('it', 'Italiano', '🇮🇹'),
  russian('ru', 'Русский', '🇷🇺'),
  portuguese('pt', 'Português', '🇵🇹'),
  arabic('ar', 'العربية', '🇸🇦'),
  hindi('hi', 'हिन्दी', '🇮🇳'),
  thai('th', 'ไทย', '🇹🇭'),
  indonesian('id', 'Bahasa Indonesia', '🇮🇩'),
  dutch('nl', 'Nederlands', '🇳🇱'),
  polish('pl', 'Polski', '🇵🇱'),
  turkish('tr', 'Türkçe', '🇹🇷');

  final String code;
  final String displayName;
  final String flag;

  const TranslationLanguage(this.code, this.displayName, this.flag);
}
