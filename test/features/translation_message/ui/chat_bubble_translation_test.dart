import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat/features/translation_message/bloc/translation_message_bloc.dart';
import 'package:public_chat/features/translation_message/data/translation_language.dart';
import 'package:public_chat/features/translation_message/ui/translation_message_screen.dart';

import '../../../material_wrapper_extension.dart';

class MockTranslationMessageBloc extends Mock
    implements TranslationMessageBloc {}

void main() {
  final MockTranslationMessageBloc translationBloc =
      MockTranslationMessageBloc();

  setUp(() {
    when(
      () => translationBloc.state,
    ).thenReturn(const TranslationMessageState());

    when(
      () => translationBloc.stream,
    ).thenAnswer(
      (_) => const Stream.empty(),
    );
  });

  tearDown(() {
    reset(translationBloc);
  });

  group('TranslationMessageScreen UI Tests', () {
    testWidgets('verify basic UI components are present', (widgetTester) async {
      const Widget widget = TranslationMessageScreen();

      await widgetTester.wrapAndPump(
        BlocProvider<TranslationMessageBloc>.value(
          value: translationBloc,
          child: widget,
        ),
      );

      // Verify AppBar components
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Translation Settings'), findsOneWidget);

      // Verify main content containers
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      // Verify all language options are present
      for (final language in TranslationLanguage.values) {
        expect(find.text(language.displayName), findsOneWidget);
        expect(
            find.text('Code: ${language.code.toUpperCase()}'), findsOneWidget);
      }
    });

    testWidgets(
      'verify language selection UI updates when a language is selected',
      (widgetTester) async {
        // Initial state with no language selected
        when(() => translationBloc.state).thenReturn(
          const TranslationMessageState(),
        );

        const Widget widget = TranslationMessageScreen();

        await widgetTester.wrapAndPump(
          BlocProvider<TranslationMessageBloc>.value(
            value: translationBloc,
            child: widget,
          ),
        );

        // Find and tap English language option
        await widgetTester.tap(
          find.text(TranslationLanguage.english.displayName),
        );

        verify(
          () => translationBloc.add(
            const TranslationLanguageChanged(TranslationLanguage.english),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'verify selected language has different styling',
      (widgetTester) async {
        // Set state with English selected
        when(() => translationBloc.state).thenReturn(
          const TranslationMessageState(
            selectedLanguage: TranslationLanguage.english,
          ),
        );

        const Widget widget = TranslationMessageScreen();

        await widgetTester.wrapAndPump(
          BlocProvider<TranslationMessageBloc>.value(
            value: translationBloc,
            child: widget,
          ),
        );

        // Find the container of the selected language item
        final selectedContainer = widgetTester.widget<Container>(
          find
              .ancestor(
                of: find.text(TranslationLanguage.english.displayName),
                matching: find.byType(Container),
              )
              .first,
        );

        // Verify the selected item has a different decoration
        final BoxDecoration decoration =
            selectedContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(12));
        expect(decoration.border?.top.width, 2);

        // Verify check icon is present for selected language
        expect(
          find.descendant(
            of: find.ancestor(
              of: find.text(TranslationLanguage.english.displayName),
              matching: find.byType(Container),
            ),
            matching: find.byIcon(Icons.check),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('verify gradient background is present', (widgetTester) async {
      const Widget widget = TranslationMessageScreen();

      await widgetTester.wrapAndPump(
        BlocProvider<TranslationMessageBloc>.value(
          value: translationBloc,
          child: widget,
        ),
      );

      final Container container = widgetTester.widget(
        find.byType(Container).first,
      );

      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
      expect(decoration.gradient is LinearGradient, isTrue);

      final LinearGradient gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors.length, 2);
      expect(gradient.begin, Alignment.topCenter);
      expect(gradient.end, Alignment.bottomCenter);
    });

    testWidgets('verify language flags are displayed correctly',
        (widgetTester) async {
      const Widget widget = TranslationMessageScreen();

      await widgetTester.wrapAndPump(
        BlocProvider<TranslationMessageBloc>.value(
          value: translationBloc,
          child: widget,
        ),
      );

      // Check if all language flags are present
      for (final language in TranslationLanguage.values) {
        expect(find.text(language.flag), findsOneWidget);

        // Verify flag container styling
        final Container flagContainer = widgetTester.widget(
          find
              .ancestor(
                of: find.text(language.flag),
                matching: find.byType(Container),
              )
              .first,
        );

        expect(flagContainer.constraints?.maxWidth, 40);
        expect(flagContainer.constraints?.maxHeight, 40);
        expect(flagContainer.alignment, Alignment.center);

        final BoxDecoration decoration =
            flagContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(8));
      }
    });
  });
}
