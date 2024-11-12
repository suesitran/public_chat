import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:public_chat/_shared/widgets/chat_bubble_widget.dart';
import 'package:public_chat/features/translation_message/bloc/translation_message_bloc.dart';

import '../../material_wrapper_extension.dart';

void main() {
  late TranslationMessageBloc translationBloc;

  setUp(() {
    translationBloc = TranslationMessageBloc();
  });

  tearDown(() {
    translationBloc.close();
  });

  Widget buildTestWidget(Widget child) {
    return BlocProvider<TranslationMessageBloc>.value(
      value: translationBloc,
      child: child,
    );
  }

  testWidgets('verify basic UI components', (widgetTester) async {
    const Widget widget = ChatBubble(
      isMine: true,
      message: 'message',
      messageId: 'test-id',
      displayName: 'displayName',
      photoUrl: null,
      selectedLanguageCode: null,
      translations: {},
    );

    await widgetTester.wrapAndPump(buildTestWidget(widget));

    expect(
      find.descendant(
        of: find.byType(Padding),
        matching: find.byType(ClipRRect),
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.byType(Text),
      ),
      findsNWidgets(2), // Display name and message
    );

    expect(
      find.descendant(
        of: find.byType(Padding),
        matching: find.byType(Row),
      ),
      findsOneWidget,
    );

    final ClipRRect rRect = widgetTester.widget(find.descendant(
      of: find.byType(Padding),
      matching: find.byType(ClipRRect),
    ));
    expect(rRect.borderRadius, BorderRadius.circular(24));

    final Padding padding = widgetTester.widget(find.descendant(
      of: find.byType(Row),
      matching: find.ancestor(
        of: find.byType(ClipRRect),
        matching: find.byType(Padding),
      ),
    ));
    expect(padding.padding, const EdgeInsets.all(8.0));

    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.text('message'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(Container),
        matching: find.text('displayName'),
      ),
      findsOneWidget,
    );

    final Container container = widgetTester.widget(find.ancestor(
      of: find.byType(Column),
      matching: find.byType(Container),
    ));
    expect(container.decoration, isNotNull);
    expect(container.decoration, isA<BoxDecoration>());

    final BoxDecoration decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(16));
    expect(container.padding, const EdgeInsets.all(8));
  });

  testWidgets(
    'given photoUrl is null, when load ChatBubble, then Icon with data Icons.person is present',
    (widgetTester) async {
      const Widget widget = ChatBubble(
        isMine: true,
        message: 'message',
        messageId: 'test-id',
        displayName: 'displayName',
        photoUrl: null,
        selectedLanguageCode: null,
        translations: {},
      );

      await widgetTester.wrapAndPump(buildTestWidget(widget));

      expect(find.byType(ImageNetwork), findsNothing);
      expect(
        find.byWidgetPredicate(
            (widget) => widget is Icon && widget.icon == Icons.person),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'given photoUrl is not null, when load ChatBubble, then ImageNetwork is present',
    (widgetTester) async {
      const Widget widget = ChatBubble(
        isMine: true,
        photoUrl: 'photoUrl',
        message: 'message',
        messageId: 'test-id',
        displayName: 'displayName',
        selectedLanguageCode: null,
        translations: {},
      );

      await widgetTester.wrapAndPump(buildTestWidget(widget));

      expect(find.byType(ImageNetwork), findsOneWidget);
    },
  );

  testWidgets(
    'given ChatBubble with isMine == true, verify alignment and styling',
    (widgetTester) async {
      const Widget widget = ChatBubble(
        isMine: true,
        photoUrl: 'photoUrl',
        message: 'message',
        messageId: 'test-id',
        displayName: 'displayName',
        selectedLanguageCode: null,
        translations: {},
      );

      await widgetTester.wrapAndPump(buildTestWidget(widget));

      final Container container = widgetTester.widget(find.ancestor(
        of: find.byType(Column),
        matching: find.byType(Container),
      ));

      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.black26);

      final Row row = widgetTester.widget(
        find.descendant(
          of: find.byType(Padding),
          matching: find.byType(Row),
        ),
      );
      expect(row.mainAxisAlignment, MainAxisAlignment.end);
    },
  );

  testWidgets(
    'given ChatBubble with isMine == false, verify alignment and styling',
    (widgetTester) async {
      const Widget widget = ChatBubble(
        isMine: false,
        photoUrl: 'photoUrl',
        message: 'message',
        messageId: 'test-id',
        displayName: 'displayName',
        selectedLanguageCode: null,
        translations: {},
      );

      await widgetTester.wrapAndPump(buildTestWidget(widget));

      final Container container = widgetTester.widget(find.ancestor(
        of: find.byType(Column),
        matching: find.byType(Container),
      ));

      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.black87);

      final Row row = widgetTester.widget(
        find.descendant(
          of: find.byType(Padding),
          matching: find.byType(Row),
        ),
      );
      expect(row.mainAxisAlignment, MainAxisAlignment.start);
    },
  );

  testWidgets(
    'when selectedLanguageCode is null, translation section should not be visible',
    (widgetTester) async {
      const Widget widget = ChatBubble(
        isMine: true,
        photoUrl: 'photoUrl',
        message: 'message',
        messageId: 'test-id',
        displayName: 'displayName',
        selectedLanguageCode: null,
        translations: {'es': 'mensaje'},
      );

      await widgetTester.wrapAndPump(buildTestWidget(widget));

      expect(find.text('translate'), findsNothing);
    },
  );
}
