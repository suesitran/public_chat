import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat/_shared/widgets/chat/chat_bubble_widget.dart';
import 'package:public_chat/_shared/widgets/chat/message_box_widget.dart';
import 'package:public_chat/features/genai_setting/bloc/genai_bloc.dart';
import 'package:public_chat/features/genai_setting/data/chat_content.dart';
import 'package:public_chat/features/genai_setting/ui/genai_setting_screen.dart';
import 'package:public_chat/features/genai_setting/ui/widgets/gen_ai_chat_bubble.dart';

import '../../../material_wrapper_extension.dart';

class MockGenaiBloc extends Mock implements GenaiBloc {}

void main() {
  final MockGenaiBloc genaiBloc = MockGenaiBloc();

  setUp(
    () {
      when(
        () => genaiBloc.state,
      ).thenAnswer(
        (_) => GenaiInitial(),
      );
      when(
        () => genaiBloc.stream,
      ).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(
        () => genaiBloc.close(),
      ).thenAnswer(
        (invocation) => Future.value(),
      );
    },
  );

  tearDown(() {
    reset(genaiBloc);
  });

  testWidgets('verify UI component', (widgetTester) async {
    const Widget widget = GenaiSettingScreen();

    await widgetTester.wrapAndPump(BlocProvider<GenaiBloc>(
      create: (context) => genaiBloc,
      child: widget,
    ));

    expect(
        find.descendant(
            of: find.byType(Scaffold),
            matching: find.ancestor(
                of: find.byType(Column), matching: find.byType(Center))),
        findsOneWidget);
    expect(
        find.descendant(of: find.byType(Center), matching: find.byType(Column)),
        findsOneWidget);

    final Column column = widgetTester.widget(find.descendant(
        of: find.byType(Center), matching: find.byType(Column)));
    expect(column.children.length, 2);
    expect(column.children.first, isA<Expanded>());
    expect(column.children.last, isA<MessageBox>());

    expect(
        find.descendant(
            of: find.byType(Expanded),
            matching: find.byType(BlocBuilder<GenaiBloc, GenaiState>)),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(BlocBuilder<GenaiBloc, GenaiState>),
            matching: find.byType(ListView)),
        findsOneWidget);
  });

  testWidgets(
      'given GenAIWorker stream return List of ChatContent,'
      ' when load MainApp,'
      ' then show ListView with number of ChatBubbles matching number of ChatContents',
      (widgetTester) async {
    // given
    when(
      () => genaiBloc.stream,
    ).thenAnswer((invocation) => Stream.value(const MessagesUpdate([
          ChatContent.user('This is a message from user'),
          ChatContent.gemini('This is a message from Gemini')
        ])));
    const Widget widget = GenaiSettingScreen();

    await widgetTester.wrapAndPump(BlocProvider<GenaiBloc>(
      create: (context) => genaiBloc,
      child: widget,
    ));
    await widgetTester.pumpAndSettle();

    // then
    expect(find.byType(GenAIChatBubble), findsNWidgets(2));
    expect(
        find.descendant(
            of: find.byType(ListView), matching: find.byType(GenAIChatBubble)),
        findsNWidgets(2));
    final ListView listView = widgetTester.widget(find.byType(ListView));
    expect(listView.childrenDelegate.estimatedChildCount, 2);
    expect(find.text('This is a message from user'), findsOneWidget);
    expect(find.text('This is a message from Gemini'), findsOneWidget);
  });

  testWidgets(
      'given GenAIWorker stream return empty list of ChatContent,'
      ' when load MainApp,'
      ' then show ListView 0 ChatBubbles', (widgetTester) async {
    // given
    when(
      () => genaiBloc.stream,
    ).thenAnswer((invocation) => Stream.value(const MessagesUpdate([])));
    const Widget widget = GenaiSettingScreen();

    await widgetTester.wrapAndPump(BlocProvider<GenaiBloc>(
      create: (context) => genaiBloc,
      child: widget,
    ));
    await widgetTester.pumpAndSettle();

    // then
    expect(find.byType(ChatBubble), findsNothing);
    expect(
        find.descendant(
            of: find.byType(ListView), matching: find.byType(ChatBubble)),
        findsNothing);
    final ListView listView = widgetTester.widget(find.byType(ListView));
    expect(listView.childrenDelegate.estimatedChildCount, 0);
  });

  testWidgets(
      'given GenAIWorker stream does not update,'
      ' when load MainApp,'
      ' then show ListView 0 ChatBubbles', (widgetTester) async {
    // given
    when(
      () => genaiBloc.stream,
    ).thenAnswer((invocation) => const Stream.empty());
    const Widget widget = GenaiSettingScreen();

    await widgetTester.wrapAndPump(BlocProvider<GenaiBloc>(
      create: (context) => genaiBloc,
      child: widget,
    ));
    await widgetTester.pumpAndSettle();

    // then
    expect(find.byType(ChatBubble), findsNothing);
    expect(
        find.descendant(
            of: find.byType(ListView), matching: find.byType(ChatBubble)),
        findsNothing);
    final ListView listView = widgetTester.widget(find.byType(ListView));
    expect(listView.childrenDelegate.estimatedChildCount, 0);
  });
}
