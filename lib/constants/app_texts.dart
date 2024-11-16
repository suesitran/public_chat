// Contains the text displayed in UI
class AppTexts {
  static const String loginButton = 'Login';
  static const String chatTitle = 'Public Chat Room';
  static const String loginErrorText = 'Login failed. Try again';
  static const String translatingStatus = 'Translating...';
  static const String translatingFailStatus =
      'Unable to translate, try again later!';
  static const noMessageFound =
      'No messages found. Send the first message now!';
  static const String clickMessage =
      'Click on the message to translate it into';
  static const String searchLanguage = 'Search language...';
  static const String userCancel = 'User cancelled';
  static const String unableGetUser = 'Unable to get user credential';

  static List<String> getAllTexts() {
    return [
      loginButton,
      chatTitle,
      loginErrorText,
      translatingStatus,
      translatingFailStatus,
      noMessageFound,
      clickMessage,
      searchLanguage,
      userCancel,
      unableGetUser,
    ];
  }
}
