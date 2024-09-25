import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:public_chat/_shared/widgets/chat_bubble_widget.dart';

import '../../material_wrapper_extension.dart';

void main() {
  testWidgets('verify UI component', (widgetTester) async {
    const Widget widget =
        ChatBubble(isMine: true, senderUid: 'uid', message: 'message');

    await widgetTester.wrapAndPump(widget);

    expect(
        find.descendant(
            of: find.byType(Padding), matching: find.byType(ClipRRect)),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(Container), matching: find.byType(Text)),
        findsOneWidget);
    expect(
        find.descendant(of: find.byType(Padding), matching: find.byType(Row)),
        findsOneWidget);

    final ClipRRect rRect = widgetTester.widget(find.descendant(
        of: find.byType(Padding), matching: find.byType(ClipRRect)));
    expect(rRect.borderRadius, BorderRadius.circular(24));

    final Padding padding = widgetTester.widget(find.descendant(
        of: find.byType(Row),
        matching: find.ancestor(
            of: find.byType(ClipRRect), matching: find.byType(Padding))));
    expect(padding.padding, const EdgeInsets.all(8.0));

    final Text text = widgetTester.widget(find.descendant(
        of: find.byType(Container), matching: find.byType(Text)));
    expect(text.data, 'message');

    final Container container = widgetTester.widget(
        find.ancestor(of: find.byType(Text), matching: find.byType(Container)));
    expect(container.decoration, isNotNull);
    expect(container.decoration, isA<BoxDecoration>());

    final BoxDecoration decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(16));
    expect(container.padding, const EdgeInsets.all(8));
  });

  testWidgets(
      'given photoUrl is null,'
      ' when load ChatBubble,'
      ' then CachedNetworkImage is not present, and Icon with data Icons.person is present',
      (widgetTester) async {
    // given
    const Widget widget =
        ChatBubble(isMine: true, senderUid: 'uid', message: 'message');

    // when
    await widgetTester.wrapAndPump(widget);

    // then
    expect(find.byType(CachedNetworkImage), findsNothing);
    expect(find.byWidgetPredicate((widget) {
      if (widget is! Icon) {
        return false;
      }

      return widget.icon == Icons.person;
    }), findsOneWidget);
  });

  testWidgets(
      'given photoUrl is not null,'
      ' when load ChatBubble,'
      ' then CachedNetworkImage is present', (widgetTester) async {
    // given
    const Widget widget =
        ChatBubble(isMine: true, senderUid: 'uid', message: 'message');

    // when
    await widgetTester.wrapAndPump(widget);

    // then
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets(
      'given ChatBubble with isMine == true,'
      ' when load ChatBubble,'
      ' then Container deco color is black26, and row alignment is end,'
      ' and Container with Text is first item in row,'
      ' and Padding with ClipRRect is last item in row', (widgetTester) async {
    // given
    const Widget widget =
        ChatBubble(isMine: true, senderUid: 'uid', message: 'message');

    // when
    await widgetTester.wrapAndPump(widget);

    // expect
    final Container container = widgetTester.widget(
        find.ancestor(of: find.byType(Text), matching: find.byType(Container)));

    final BoxDecoration decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.black26);

    final Row row = widgetTester.widget(
        find.descendant(of: find.byType(Padding), matching: find.byType(Row)));
    expect(row.mainAxisAlignment, MainAxisAlignment.end);

    expect(row.children.length, 2);
    // verify Container wrapper for Text is present
    expect(row.children.first, isA<Container>());
    // verify Padding wrapper for ClipRRect is preset
    expect(row.children.last, isA<Padding>());
  });

  testWidgets(
      'given ChatBubble with isMine == false,'
      ' when load ChatBubble,'
      ' then Container deco color is black87, and row alignment is start,'
      ' and Padding with ClipRRect is first item in row,'
      ' and Container with Text is second item in row', (widgetTester) async {
    // given
    const Widget widget =
        ChatBubble(isMine: false, senderUid: 'uid', message: 'message');

    // when
    await widgetTester.wrapAndPump(widget);

    // expect
    final Container container = widgetTester.widget(
        find.ancestor(of: find.byType(Text), matching: find.byType(Container)));

    final BoxDecoration decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.black87);

    final Row row = widgetTester.widget(
        find.descendant(of: find.byType(Padding), matching: find.byType(Row)));
    expect(row.mainAxisAlignment, MainAxisAlignment.start);

    expect(row.children.length, 2);
    // verify Padding wrapper for ClipRRect is preset
    expect(row.children.first, isA<Padding>());
    // verify Container wrapper for Text is present
    expect(row.children.last, isA<Container>());
  });
}
