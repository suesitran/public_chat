import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'translate_text.dart';

class TranslateTextImpl extends TranslateText {
  TranslateTextImpl();
  final translator = GoogleTranslator();

  @override
  Future<Translation> translate(
    String original, {
    Locale? fromLocale,
    required Locale toLocale,
  }) {
    return translator
        .translate(
      original,
      from: fromLocale?.languageCode ?? 'auto',
      to: toLocale.languageCode,
    )
        .then((Translation result) {
      print("Source: $original\nTranslated: $result");
      return result;
    });
  }
}
