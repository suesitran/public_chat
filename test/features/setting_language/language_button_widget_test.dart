import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat/features/language_setting/bloc/user_language_cubit.dart';
import 'package:public_chat/features/language_setting/ui/widgets/button_language_setting/button_language_setting.dart';
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

  testWidgets('verify setting user languge vi', (widgetTester) async {
    when(
      () => languageCubit.state,
    ).thenAnswer(
      (_) => 'vi',
    );
    const Widget widget = ButtonLanguageSetting();

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

    expect(find.text('🇻🇳'), findsOneWidget);
  });

  testWidgets('verify setting user languge en', (widgetTester) async {
    when(
      () => languageCubit.state,
    ).thenAnswer(
      (_) => 'en',
    );
    const Widget widget = ButtonLanguageSetting();

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

    expect(find.text('🇺🇸'), findsOneWidget);
  });

  testWidgets('click button', (widgetTester) async {
    when(
      () => languageCubit.state,
    ).thenAnswer(
      (_) => 'vi',
    );
    const Widget widget = ButtonLanguageSetting();

    await widgetTester.wrapAndPumpWithProvider(
        widget,
        [
          BlocProvider<UserLanguageCubit>(
            create: (context) => languageCubit,
          ),
          BlocProvider<LanguageSupportCubit>(
            create: (context) => supportLanguage,
          ),
        ],
        locale: const Locale('vi'));

    final buttonFinder = find.byType(ButtonLanguageSetting);
    await widgetTester.tap(buttonFinder);
    await widgetTester.pumpAndSettle();

    expect(find.text('Cài đặt ngôn ngữ'), findsOneWidget);
  });
}
