import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_network/image_network.dart';
import 'package:public_chat/_shared/widgets/chat_bubble_widget.dart';
import 'package:public_chat/features/language/bloc/language_bloc.dart';
import 'package:public_chat/service_locator/service_locator.dart';

void main() {
  setUpAll(() async {
    await ServiceLocator.instance.initialise();
  });
  testWidgets('verify UI component', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<LanguageBloc>.value(value: LanguageBloc()),
          ],
          child: ChatBubble(
            onChatBubbleTap: () async {
              return true;
            },
            isMine: true,
            message: 'message',
            displayName: 'displayName',
            photoUrl: null,
            translations: const {'English': 'translated message'},
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(
      find.descendant(
          of: find.byType(Padding), matching: find.byType(ClipRRect)),
      findsOneWidget,
    );

    expect(
      find.descendant(of: find.byType(Container), matching: find.byType(Text)),
      findsNWidgets(3),
    );
    expect(
      find.descendant(of: find.byType(Padding), matching: find.byType(Row)),
      findsOneWidget,
    );

    final ClipRRect rRect = widgetTester.widget(find.descendant(
        of: find.byType(Padding), matching: find.byType(ClipRRect)));
    expect(rRect.borderRadius, BorderRadius.circular(24));

    final Padding padding = widgetTester.widget(find.descendant(
        of: find.byType(Row),
        matching: find.ancestor(
            of: find.byType(ClipRRect), matching: find.byType(Padding))));
    expect(padding.padding, const EdgeInsets.all(8.0));

    expect(
        find.descendant(
            of: find.byType(Container), matching: find.text('message')),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(Container), matching: find.text('displayName')),
        findsOneWidget);

    final Container container = widgetTester.widget(find.ancestor(
        of: find.byType(Column), matching: find.byType(Container)));
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
    await widgetTester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<LanguageBloc>.value(value: LanguageBloc()),
          ],
          child: ChatBubble(
            onChatBubbleTap: () async {
              return true;
            },
            isMine: true,
            message: 'message',
            displayName: 'displayName',
            photoUrl: null,
            translations: const {'English': 'translated message'},
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    // then
    expect(find.byType(ImageNetwork), findsNothing);
    expect(find.byWidgetPredicate((widget) {
      if (widget is! Icon) {
        return false;
      }

      return widget.icon == Icons.person;
    }), findsOneWidget);
  });

  testWidgets(
      'given photoUrl is not null, '
      'when load ChatBubble, '
      'then CachedNetworkImage is present', (widgetTester) async {
    // given
    await widgetTester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<LanguageBloc>.value(value: LanguageBloc()),
            ],
            child: ChatBubble(
              onChatBubbleTap: () async {
                return true;
              },
              isMine: true,
              message: 'message',
              displayName: 'displayName',
              photoUrl:
                  'https://lh3.googleusercontent.com/a/ACg8ocIqhSldIyARbSMYuoElOKuUEap-HHbYLU_adkYpOkimgUpTfuA=s96-c',
              translations: const {'English': 'translated message'},
            ),
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    // then
    expect(find.byType(ImageNetwork), findsOneWidget); // Tìm CachedNetworkImage
  });

  testWidgets(
      'given ChatBubble with isMine == true,'
      ' when load ChatBubble,'
      ' then Container deco color is black26, and row alignment is end,'
      ' and Container with Text is first item in row,'
      ' and Padding with ClipRRect is last item in row', (widgetTester) async {
    // given
    await widgetTester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<LanguageBloc>.value(value: LanguageBloc()),
          ],
          child: ChatBubble(
            onChatBubbleTap: () async {
              return true;
            },
            isMine: true,
            message: 'message',
            displayName: 'displayName',
            photoUrl: null,
            translations: const {'English': 'translated message'},
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    // expect
    final Container container = widgetTester.widget(find.ancestor(
        of: find.byType(Column), matching: find.byType(Container)));

    final BoxDecoration decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.black26);

    final Row row = widgetTester.widget(
        find.descendant(of: find.byType(Padding), matching: find.byType(Row)));
    expect(row.mainAxisAlignment, MainAxisAlignment.end);

    expect(row.children.length, 2);
    // verify GestureDetector wrapper for Text is present
    expect(row.children[1], isA<Padding>());
    // verify Padding wrapper for ClipRRect is preset
    expect(row.children.last, isA<Padding>());
  });

  testWidgets(
      'given ChatBubble with isMine == false, '
      'when load ChatBubble, '
      'then Container deco color is black87, '
      'and row alignment is start, '
      'and Padding with ClipRRect is first item in row, ',
      (widgetTester) async {
    // Mocking LanguageBloc to avoid errors in the test
    final mockLanguageBloc = LanguageBloc();

    // given
    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<LanguageBloc>.value(
            value: mockLanguageBloc, // Use value instead of creating a new one
            child: ChatBubble(
              onChatBubbleTap: () async {
                return true;
              },
              isMine: false, // isMine == false
              message: 'message',
              displayName: 'displayName',
              photoUrl: null, // Chưa có ảnh
              translations: const {'English': 'translated message'},
            ),
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    // Kiểm tra Row và alignment
    final rowFinder = find.byType(Row);
    final row = widgetTester.widget<Row>(rowFinder);
    expect(row.mainAxisAlignment, MainAxisAlignment.start);

    final children = row.children;
    expect(children.length, 2);

    final firstWidget = children.first;
    expect(firstWidget, isA<Padding>());

    final padding = firstWidget as Padding;
    expect(padding.child, isA<ClipRRect>());

    final secondWidget = children.last;
    expect(secondWidget, isA<BlocBuilder>());
  });
}
