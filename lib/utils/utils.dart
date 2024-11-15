class Utils {
  static String getTranslationPromtMessage({
    required String message,
    required String newLanguage,
  }) {
    return '''
      Translate this message '$message' into $newLanguage then return for me only the translated message. If there is any special perpetuating harmful stereotypes return translated message with another short message to notice use with the perpetuating harmful stereotypes in $newLanguage else show no additional message.
    ''';
  }
}
