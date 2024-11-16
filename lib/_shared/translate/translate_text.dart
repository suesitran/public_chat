import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

abstract class TranslateText {
  Future<Translation> translate(
    String original, {
    Locale? fromLocale,
    required Locale toLocale,
  });
}
