// 30 languages have ​​supported on Gemini in Android, ios devices and in Gemini Prompt
final List<Map<String, String>> supportedLanguages = [
  {"name": "English", "flagUrl": "https://flagcdn.com/w80/gb.png"},
  {"name": "Arabic", "flagUrl": "https://flagcdn.com/w80/sa.png"},
  {"name": "Chinese", "flagUrl": "https://flagcdn.com/w80/cn.png"},
  {"name": "Croatian", "flagUrl": "https://flagcdn.com/w80/hr.png"},
  {"name": "Czech", "flagUrl": "https://flagcdn.com/w80/cz.png"},
  {"name": "Danish", "flagUrl": "https://flagcdn.com/w80/dk.png"},
  {"name": "Dutch", "flagUrl": "https://flagcdn.com/w80/nl.png"},
  {"name": "Finnish", "flagUrl": "https://flagcdn.com/w80/fi.png"},
  {"name": "French", "flagUrl": "https://flagcdn.com/w80/fr.png"},
  {"name": "German", "flagUrl": "https://flagcdn.com/w80/de.png"},
  {"name": "Greek", "flagUrl": "https://flagcdn.com/w80/gr.png"},
  {"name": "Hebrew", "flagUrl": "https://flagcdn.com/w80/il.png"},
  {"name": "Hungarian", "flagUrl": "https://flagcdn.com/w80/hu.png"},
  {"name": "Hindi", "flagUrl": "https://flagcdn.com/w80/in.png"},
  {"name": "Indonesian", "flagUrl": "https://flagcdn.com/w80/id.png"},
  {"name": "Italian", "flagUrl": "https://flagcdn.com/w80/it.png"},
  {"name": "Japanese", "flagUrl": "https://flagcdn.com/w80/jp.png"},
  {"name": "Korean", "flagUrl": "https://flagcdn.com/w80/kr.png"},
  {"name": "Norwegian", "flagUrl": "https://flagcdn.com/w80/no.png"},
  {"name": "Polish", "flagUrl": "https://flagcdn.com/w80/pl.png"},
  {"name": "Portuguese", "flagUrl": "https://flagcdn.com/w80/pt.png"},
  {"name": "Romanian", "flagUrl": "https://flagcdn.com/w80/ro.png"},
  {"name": "Russian", "flagUrl": "https://flagcdn.com/w80/ru.png"},
  {"name": "Slovak", "flagUrl": "https://flagcdn.com/w80/sk.png"},
  {"name": "Spanish", "flagUrl": "https://flagcdn.com/w80/es.png"},
  {"name": "Swedish", "flagUrl": "https://flagcdn.com/w80/se.png"},
  {"name": "Turkish", "flagUrl": "https://flagcdn.com/w80/tr.png"},
  {"name": "Thai", "flagUrl": "https://flagcdn.com/w80/th.png"},
  {"name": "Ukrainian", "flagUrl": "https://flagcdn.com/w80/ua.png"},
  {"name": "Vietnamese", "flagUrl": "https://flagcdn.com/w80/vn.png"},
];

class LanguageSupport {
  final String name;
  final String flagUrl;

  LanguageSupport({required this.name, required this.flagUrl});
}

final List<LanguageSupport> supportedLanguageObjects =
    supportedLanguages.map((language) {
  return LanguageSupport(
    name: language['name']!,
    flagUrl: language['flagUrl']!,
  );
}).toList();

const String defaultLanguage = "English";
