class LanguageUtils {
  static String mapLanguageNameToLanguageCode(String data) {
    switch (data) {
      case 'Tiếng Việt':
        return 'vi';
      case 'Tiếng Anh':
        return 'en';
      case 'English':
        return 'en';
      default:
        return 'vi';
    }
  }
}
