import 'package:translator/translator.dart';

import '../main.dart';

Future<String> translate(String text,
    {String? to, String from = 'auto'}) async {
  try {
    return (await GoogleTranslator().translate(text,
            // to: 'vi', from: 'auto',
            to: to ?? defaultLanguageCode,
            from: from))
        .text;
  } catch (e) {
    return "Không tìm thấy ngôn ngữ '$to' (dịch từ ngôn ngữ '$from')";
  }
}
