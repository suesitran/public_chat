enum GenAiLanguage {
  auto("", "", ""),
  arabic("sa", "Arabic", "العربية"),
  bengali("bd", "Bengali", "বাংলা"),
  bulgarian("bg", "Bulgarian", "български"),
  chineseSimplified("cn", "Chinese (Simplified)", "简体中文"),
  chineseTraditional("tw", "Chinese (Traditional)", "繁體中文"),
  croatian("hr", "Croatian", "Hrvatski"),
  czech("cz", "Czech", "Čeština"),
  danish("dk", "Danish", "Dansk"),
  dutch("nl", "Dutch", "Nederlands"),
  english("gb", "English", "English"),
  estonian("ee", "Estonian", "Eesti"),
  finnish("fi", "Finnish", "Suomi"),
  french("fr", "French", "Français"),
  german("de", "German", "Deutsch"),
  greek("gr", "Greek", "Ελληνικά"),
  gujarati("in", "Gujarati", "ગુજરાતી"),
  hebrew("il", "Hebrew", "עברית"),
  hindi("in", "Hindi", "हिन्दी"),
  hungarian("hu", "Hungarian", "Magyar"),
  indonesian("id", "Indonesian", "Bahasa Indonesia"),
  italian("it", "Italian", "Italiano"),
  japanese("jp", "Japanese", "日本語"),
  kannada("in", "Kannada", "ಕನ್ನಡ"),
  korean("kr", "Korean", "한국어"),
  latvian("lv", "Latvian", "Latviešu"),
  lithuanian("lt", "Lithuanian", "Lietuvių"),
  malayalam("in", "Malayalam", "മലയാളം"),
  marathi("in", "Marathi", "मराठी"),
  norwegian("no", "Norwegian", "Norsk"),
  polish("pl", "Polish", "Polski"),
  portuguese("pt", "Portuguese", "Português"),
  romanian("ro", "Romanian", "Română"),
  russian("ru", "Russian", "Русский"),
  serbian("rs", "Serbian", "Српски"),
  slovak("sk", "Slovak", "Slovenčina"),
  slovenian("si", "Slovenian", "Slovenščina"),
  spanish("es", "Spanish", "Español"),
  swahili("tz", "Swahili", "Kiswahili"),
  swedish("se", "Swedish", "Svenska"),
  tamil("in", "Tamil", "தமிழ்"),
  telugu("in", "Telugu", "తెలుగు"),
  thai("th", "Thai", "ไทย"),
  turkish("tr", "Turkish", "Türkçe"),
  ukrainian("ua", "Ukrainian", "Українська"),
  urdu("pk", "Urdu", "اردو"),
  vietnamese("vn", "Vietnamese", "Tiếng Việt");

  final String countryCode;
  final String languageName;
  final String displayName;

  String get imageUrl => 'https://flagcdn.com/${countryCode.toLowerCase()}.svg';

  const GenAiLanguage(this.countryCode, this.languageName, this.displayName);
}
