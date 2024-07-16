import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:public_chat/widgets/message_box_widget.dart';

import '../material_wrapper_extension.dart';

void main() {
  testWidgets('verify UI components', (widgetTester) async {
    final Widget widget = MessageBox(
      onSendMessage: (value) {},
    );

    await widgetTester.wrapAndPump(widget);

    expect(
        find.descendant(
            of: find.byType(Padding), matching: find.byType(TextField)),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(TextField), matching: find.byType(IconButton)),
        findsOneWidget);
  });

  testWidgets(
      'given MessageBox is loaded,'
      ' when tap on IconButton in TextField'
      ' then onSendMessage is triggered', (widgetTester) async {
    String result = '';

    final Widget widget = MessageBox(
      onSendMessage: (value) {
        result = value;
      },
    );

    await widgetTester.wrapAndPump(widget);
    await widgetTester.enterText(
        find.byType(TextField), 'This is a simple message');
    await widgetTester.tap(find.descendant(
        of: find.byType(TextField), matching: find.byType(IconButton)));

    expect(result, 'This is a simple message');
  });

  testWidgets(
      'given MessageBox is loaded,'
      ' when enter action Done in TextField'
      ' then onSendMessage is triggered', (widgetTester) async {
    String result = '';

    final Widget widget = MessageBox(
      onSendMessage: (value) {
        result = value;
      },
    );

    await widgetTester.wrapAndPump(widget);
    await widgetTester.enterText(
        find.byType(TextField), 'This is a simple message');
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);

    expect(result, 'This is a simple message');
  });
}
