import 'package:google_generative_ai/google_generative_ai.dart';

class GenAiModel {
  late final GenerativeModel _model;
  late final ChatSession _session;

  GenAiModel() {
    const apiKey = String.fromEnvironment('apiKey');

    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey,

      // Specify the function declaration.
      tools: [
        Tool(functionDeclarations: [lightControlTool])
      ],
    );

    _session = _model.startChat();
  }

  Future<GenerateContentResponse> sendMessage(Content content) =>
      _session.sendMessage(content);

  final lightControlTool = FunctionDeclaration(
      'translate',
      'translate the message into another language',
      Schema(SchemaType.object, properties: {
        'message': Schema(SchemaType.string,
            description:
                'Text that needs to be translated into another language'),
        'targetLanguage': Schema(SchemaType.string,
            description: 'The language the text needs to be translated into, '
                'which can be `English`, `Arabic`, `Chinese`, `Croatian`, `Czech`, `Danish`, `Dutch`, `Finnish`, `French`, `German`, `Greek`, `Hebrew`, `Hungarian`, `Hindi`, `Indonesian`, `Italian`, `Japanese`, `Korean`, `Norwegian`, `Polish`, `Portuguese`, `Romanian`, `Russian`, `Slovak`, `Spanish`, `Swedish`, `Turkish`, `Thai`, `Ukrainian`, or `Vietnamese`.'),
      }, requiredProperties: [
        'message',
        'targetLanguage'
      ]));
}
