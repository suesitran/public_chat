import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = String.fromEnvironment('apiKey');

class GenAiModel {
  ChatSession? _session;

  GenAiModel() {
    _initModel();
  }

  _initModel({String? systemInstruction}) {
    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      systemInstruction:
          systemInstruction != null ? Content.text(systemInstruction) : null,
    );

    _session = model.startChat(history: _session?.history.toList());
  }

  void updateLanguage({required String? language}) {
    final systemInstruction =
        language != null ? "You are an assistant, answer in $language" : null;

    _initModel(systemInstruction: systemInstruction);
  }

  Future<GenerateContentResponse> sendMessage(Content content) =>
      _session!.sendMessage(content);
}
