import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat/features/language_setting/bloc/user_language_cubit.dart';
import 'package:public_chat/features/language_setting/ui/language_setting_screen.dart';
import 'package:public_chat/features/language_support/bloc/language_support_cubit.dart';
import 'package:public_chat/features/language_support/data/language.dart';

import '../../constants.dart';
import '../../material_wrapper_extension.dart';

class MockUserLanguageCubit extends Mock implements UserLanguageCubit {}

class MockSupportLanguageCubit extends Mock implements LanguageSupportCubit {}

void main() {
  final MockUserLanguageCubit languageCubit = MockUserLanguageCubit();
  final MockSupportLanguageCubit supportLanguage = MockSupportLanguageCubit();

  setUpAll(
    () async {
      when(
        () => languageCubit.stream,
      ).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(
        () => languageCubit.close(),
      ).thenAnswer(
        (invocation) => Future.value(),
      );
      when(
        () => supportLanguage.state,
      ).thenAnswer(
        (_) => listSupportLanguge.map(
          (e) {
            return LanguageSupport.fromMap(e);
          },
        ).toList(),
      );
      when(
        () => supportLanguage.stream,
      ).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(
        () => supportLanguage.close(),
      ).thenAnswer(
        (invocation) => Future.value(),
      );
    },
  );

  tearDown(() {
    reset(languageCubit);
    reset(supportLanguage);
  });

  testWidgets('verify choose languge vi', (widgetTester) async {
    when(
      () => languageCubit.state,
    ).thenAnswer(
      (_) => 'vi',
    );
    const Widget widget = LanguageSettingScreen();

    await widgetTester.wrapAndPump(MultiBlocProvider(
      providers: [
        BlocProvider<UserLanguageCubit>(
          create: (context) => languageCubit,
        ),
        BlocProvider<LanguageSupportCubit>(
          create: (context) => supportLanguage,
        ),
      ],
      child: widget,
    ));

    final firstCountryFinder = find.text('🇿🇦');
    expect(firstCountryFinder, findsOneWidget);
    final textFinder = find.text('🇻🇳');
    await widgetTester.scrollUntilVisible(textFinder, 500.0,
    scrollable: find.byType(Scrollable),);

    // Verify the text is found
    expect(textFinder, findsOneWidget);

    final radioButtonFinder = find.ancestor(
      of: textFinder,
      matching: find.byType(RadioListTile<LanguageSupport>),
    );

    final RadioListTile<LanguageSupport> radioButton = widgetTester.widget(radioButtonFinder);
    expect(radioButton.value, equals(const LanguageSupport(code: 'vi')));
  });

  testWidgets('test choose another language', (widgetTester) async {
    when(
      () => languageCubit.state,
    ).thenAnswer(
      (_) => 'vi',
    );
    const Widget widget = LanguageSettingScreen();

    await widgetTester.wrapAndPump(MultiBlocProvider(
      providers: [
        BlocProvider<UserLanguageCubit>(
          create: (context) => languageCubit,
        ),
        BlocProvider<LanguageSupportCubit>(
          create: (context) => supportLanguage,
        ),
      ],
      child: widget,
    ));

    final textFinder = find.text('🇺🇸');
    await widgetTester.scrollUntilVisible(textFinder, 500.0,
    scrollable: find.byType(Scrollable),);

    // Verify the text is found
    expect(textFinder, findsOneWidget);

    final radioButtonFinder = find.ancestor(
      of: textFinder,
      matching: find.byType(RadioListTile<LanguageSupport>),
    );

    final RadioListTile<LanguageSupport> radioButton = widgetTester.widget(radioButtonFinder);
    expect(radioButton.value, equals(const LanguageSupport(code: 'vi')));
  });

}
