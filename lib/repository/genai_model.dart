import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenAiModel {
  late final GenerativeModel _modelSingleTranslate;
  late final GenerativeModel _modelTranslateBatch;
  late final ChatSession _singleTranslateSession;
  late final ChatSession _translateBatchSession;

  GenAiModel() {
    const apiKey = String.fromEnvironment('apiKey');

    _modelSingleTranslate = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,

      // Specify the function declaration.
      tools: [
        Tool(functionDeclarations: [translateMessageTool])
      ],
    );

    _modelTranslateBatch = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,

      // Specify the function declaration.
      tools: [
        Tool(functionDeclarations: [translateMessagesBatchTool])
      ],
    );

    _singleTranslateSession = _modelSingleTranslate.startChat();
    _translateBatchSession = _modelTranslateBatch.startChat();
  }

  // Send message to gemini
  Future<GenerateContentResponse> sendMessage(Content content) =>
      _singleTranslateSession.sendMessage(content);

  // Tool for single translation
  // tool to translate one message to targetLanguage
  final translateMessageTool = FunctionDeclaration(
      'translate',
      'translate the message into another language',
      Schema(SchemaType.object, properties: {
        'message': Schema(SchemaType.string,
            description:
                'Text that needs to be translated into another language'),
        'targetLanguage': Schema(SchemaType.string,
            description: 'The language the text needs to be translated into, '
                'which can be `English`, `Arabic`, `Chinese`, `Croatian`, `Czech`, `Danish`, `Dutch`, `Finnish`, '
                '`French`, `German`, `Greek`, `Hebrew`, `Hungarian`, `Hindi`, `Indonesian`, `Italian`, `Japanese`, '
                '`Korean`, `Norwegian`, `Polish`, `Portuguese`, `Romanian`, `Russian`, `Slovak`, `Spanish`, '
                '`Swedish`, `Turkish`, `Thai`, `Ukrainian`, or `Vietnamese`.'),
      }, requiredProperties: [
        'message',
        'targetLanguage'
      ]));

  // Tool for batch translation
  // tool to translate multi message to targetLanguage
  final translateMessagesBatchTool = FunctionDeclaration(
      'translateMessagesBatch',
      'Translate a list of messages into the another language.',
      Schema(SchemaType.object, properties: {
        'messages': Schema(SchemaType.array,
            items: Schema(SchemaType.string),
            description: 'List of text messages to be translated'),
        'targetLanguage': Schema(SchemaType.string,
            description: 'The target language for translation'
                'which can be `English`, `Arabic`, `Chinese`, `Croatian`, `Czech`, `Danish`, `Dutch`, `Finnish`, '
                '`French`, `German`, `Greek`, `Hebrew`, `Hungarian`, `Hindi`, `Indonesian`, `Italian`, `Japanese`, '
                '`Korean`, `Norwegian`, `Polish`, `Portuguese`, `Romanian`, `Russian`, `Slovak`, `Spanish`, '
                '`Swedish`, `Turkish`, `Thai`, `Ukrainian`, or `Vietnamese`.'),
      }, requiredProperties: [
        'messages',
        'targetLanguage'
      ]));

  Future<Map<String, String>> translateMessagesBatch(
      List<String> input, String targetLanguage) async {
    // output result
    final Map<String, String> translations = {};

    try {
      var response = await _translateBatchSession.sendMessage(
        Content.text(
          "Translate the following messages: [${input.map((msg) => "'$msg'").join(", ")}]; "
          "into targetLanguage: '$targetLanguage', response to me only the list of translated messages  , one line per message.",
        ),
      );

      final functionCalls = response.functionCalls.toList();
      if (functionCalls.isNotEmpty) {
        final functionCall = functionCalls.first;

        final result = switch (functionCall.name) {
          'translateMessagesBatch' =>
            await setTranslateValue(functionCall.args),
          _ => throw UnimplementedError(
              'Function not implemented: ${functionCall.name}')
        };

        // Send back the function response with the translation
        response = await _translateBatchSession.sendMessage(
          Content.functionResponse(functionCall.name, result),
        );

        if (response.text != null && response.text!.isNotEmpty) {
          final translatedLines = response.text!.split('\n');

          for (int i = 0; i < input.length && i < translatedLines.length; i++) {
            translations[input[i]] = translatedLines[i].trim();
            if (kDebugMode) {
              print("Mapped: '${input[i]}' -> '${translatedLines[i].trim()}'");
            }
          }
        } else {
          if (kDebugMode) {
            print("No translation result returned for messages.");
          }
        }
      } else {
        if (kDebugMode) {
          print("No function calls found in the response.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error translating messages batch: $e");
      }
    }

    return translations;
  }

  Future<Map<String, Object?>> setTranslateValue(
    Map<String, Object?> arguments,
  ) async {
    final messages = (arguments['messages'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return {
      'messages': messages,
      'targetLanguage': arguments['targetLanguage'],
    };
  }
}
