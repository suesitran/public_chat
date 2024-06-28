import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat/main.dart';
import 'package:public_chat/widgets/chat_bubble_widget.dart';
import 'package:public_chat/widgets/message_box_widget.dart';
import 'package:public_chat/worker/genai_worker.dart';

class MockGenAIWorker extends Mock implements GenAIWorker {}

void main() {
  final MockGenAIWorker worker = MockGenAIWorker();

  tearDown(() {
    reset(worker);
  });

  testWidgets('verify UI component', (widgetTester) async {
    final Widget widget = MainApp();

    await widgetTester.pumpWidget(widget);

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
            matching: find.byType(StreamBuilder<List<ChatContent>>)),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(StreamBuilder<List<ChatContent>>),
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
      () => worker.stream,
    ).thenAnswer((invocation) => Stream.value([
          ChatContent.user('This is a message from user'),
          ChatContent.gemini('This is a message from Gemini')
        ]));
    final Widget widget = MainApp(
      worker: worker,
    );

    await widgetTester.pumpWidget(widget);
    await widgetTester.pumpAndSettle();

    // then
    expect(find.byType(ChatBubble), findsNWidgets(2));
    expect(
        find.descendant(
            of: find.byType(ListView), matching: find.byType(ChatBubble)),
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
      () => worker.stream,
    ).thenAnswer((invocation) => Stream.value([]));
    final Widget widget = MainApp(
      worker: worker,
    );

    await widgetTester.pumpWidget(widget);
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
      () => worker.stream,
    ).thenAnswer((invocation) => Stream.empty());
    final Widget widget = MainApp(
      worker: worker,
    );

    await widgetTester.pumpWidget(widget);
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
