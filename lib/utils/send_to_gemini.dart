import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../_shared/dialog/message_dialog.dart';

Future<Map<String, dynamic>> sendToGenmini({
  required String msg,
  required List<String> languages,
}) async {
  String? apiKey = Platform.environment['GEMINI_API_KEY'];
  if (apiKey == null) {
    stderr.writeln(r'No $GEMINI_API_KEY environment variable');
    exit(1);
  }
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 1,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
    ),
  );
  final generationConfig = GenerationConfig(
    temperature: 1,
    topP: 0.95,
    topK: 64,
    maxOutputTokens: 8192,
    responseMimeType: 'application/json',
    responseSchema: Schema(SchemaType.object, properties: {
      'translations': Schema(
        SchemaType.object,
        properties: Map.fromEntries(
            languages.map((lang) => MapEntry(lang, Schema(SchemaType.string)))),
        requiredProperties: languages,
      )
    }, requiredProperties: [
      'translations'
    ]),
  );
  final prompt =
      '''Translate "$msg" to these languages/language codes: ${languages.toString()},
    You must return the translations in JSON format with language codes as keys, e.g: {"en": "English translation", "fr": "French translation"}''';
  final chatSession = model.startChat(generationConfig: generationConfig);
  final result = await chatSession.sendMessage(Content.text(prompt));
  final jsonTranslated = result.text;
  // {"translations": {"en": "Hello, this is a test. I am Dương"}}
  Map<String, String>? translated;
  if (jsonTranslated != null) {
    translated = jsonDecode(jsonTranslated)['translations'];
//{en: Hello, this is a test. I am Dương}
  } else {
    MessageDialog.showError('Gemini trả về phản hồi null');
  }
  return translated ?? {};
}
