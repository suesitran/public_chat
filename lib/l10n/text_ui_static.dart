class TextsUIStatic {
  Map<String, Map<String, String>> _text = {
    'loginTitle': {
      'en': 'Login',
    },
    'loginSuccessMessage': {
      'en': 'Login successfully',
    },
    'loginFailMessage': {
      'en': 'Login failed. Try again',
    },
    'logoutTitle': {
      'en': 'Logout',
    },
    'logoutSuccessMessage': {
      'en': 'Logout successfully',
    },
    'logoutFailMessage': {
      'en': 'Logout failed. Try again',
    },
    'chatScreenTitle': {
      'en': 'Public Room',
    },
    'languageTitle': {
      'en': 'Language',
    },
    'emptyMessageChat': {
      'en': 'No messages found. Send the first message now!',
    },
    'countryScreenTitle': {
      'en': 'Countries',
    },
    'notificationTitle': {
      'en': 'Notification',
    },
    'confirmTitle': {
      'en': 'Confirm',
    },
    'noticeSelectCountryText': {
      'en': 'Select country or use country default to use app',
    },
    'confirmSelectCountryText': {
      'en': 'Are you sure you want to use language of',
    },
    'buttonCloseTitle': {
      'en': 'Close',
    },
    'buttonOKTitle': {
      'en': 'OK',
    },
    'buttonSelectTitle': {
      'en': 'Select',
    },
    'buttonGoTitle': {
      'en': 'Go',
    },
  };

  Map<String, Map<String, String>> get texts => _text;

  set setTexts(Map<String, Map<String, String>> newTexts) =>
      _text = newTexts;
}
