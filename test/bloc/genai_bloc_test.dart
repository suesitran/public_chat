import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat/bloc/genai_bloc.dart';
import 'package:public_chat/data/chat_content.dart';
import 'package:public_chat/repository/genai_model.dart';
import 'package:public_chat/service_locator/service_locator.dart';

class MockGenAiModel extends Mock implements GenAiModel {}

void main() {
  final MockGenAiModel model = MockGenAiModel();

  setUpAll(
    () {
      ServiceLocator.instance.registerSingletonIfNeeded<GenAiModel>(model);
    },
  );

  tearDown(
    () {
      reset(model);
    },
  );

  tearDownAll(
    () {
      ServiceLocator.instance.reset();
    },
  );

  blocTest(
    'given generateContent response success, and text is null,'
    ' when sendToGemini,'
    ' then return preset response',
    build: () => GenaiBloc(),
    setUp: () {
      // given
      when(
        () => model.sendMessage(any()),
      ).thenAnswer(
        (invocation) => Future.value(GenerateContentResponse(
          [Candidate(Content('user', []), null, null, null, null)],
          null,
        )),
      );
    },
    act: (bloc) {
      // when
      bloc.add(const SendMessageEvent('This is my message'));
    },
    expect: () => [isA<MessagesUpdate>(), isA<MessagesUpdate>()],
    verify: (bloc) {
      MessagesUpdate state = bloc.state as MessagesUpdate;
      expect(state.contents.length, 2);
      expect(state.contents.first.sender, Sender.user);
      expect(state.contents.first.message, 'This is my message');

      expect(state.contents.last.sender, Sender.gemini);
      expect(state.contents.last.message, 'Unable to generate response');
    },
  );

  blocTest(
    'given generateContent response success, and text is available,'
    ' when sendToGemini,'
    ' then return responded text',
    build: () => GenaiBloc(),
    setUp: () {
      when(
        () => model.sendMessage(any()),
      ).thenAnswer((invocation) => Future.value(GenerateContentResponse(
            [
              Candidate(
                  Content.model([TextPart('this is message from gemini')]),
                  null,
                  null,
                  null,
                  null)
            ],
            null,
          )));
    },
    act: (bloc) => bloc.add(const SendMessageEvent('This is my message')),
    expect: () => [isA<MessagesUpdate>(), isA<MessagesUpdate>()],
    verify: (bloc) {
      MessagesUpdate state = bloc.state as MessagesUpdate;

      expect(state.contents.length, 2);
      expect(state.contents.first.sender, Sender.user);
      expect(state.contents.first.message, 'This is my message');

      expect(state.contents.last.sender, Sender.gemini);
      expect(state.contents.last.message, 'this is message from gemini');
    },
  );

  blocTest(
    'given generateContent failed to response,'
    ' when sendToGemini,'
    ' then return preset text',
    build: () => GenaiBloc(),
    setUp: () {
      when(
        () => model.sendMessage(any()),
      ).thenThrow(Exception('anything'));
    },
    act: (bloc) => bloc.add(const SendMessageEvent('This is my message')),
    expect: () => [isA<MessagesUpdate>(), isA<MessagesUpdate>()],
    verify: (bloc) {
      MessagesUpdate state = bloc.state as MessagesUpdate;
      expect(state.contents.length, 2);
      expect(state.contents.first.sender, Sender.user);
      expect(state.contents.first.message, 'This is my message');

      expect(state.contents.last.sender, Sender.gemini);
      expect(state.contents.last.message, 'Unable to generate response');
    },
  );
}
