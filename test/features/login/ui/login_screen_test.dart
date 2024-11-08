import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat/features/settings/locale/bloc/locale_bloc.dart';
import 'package:public_chat/features/login/ui/login_screen.dart';

import '../../../material_wrapper_extension.dart';

class MockLocaleBloc extends Mock implements LocaleBloc {}

void main() {
  final MockLocaleBloc localeBloc = MockLocaleBloc();

  setUp(
    () {
      when(
        () => localeBloc.stream,
      ).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(
        () => localeBloc.close(),
      ).thenAnswer(
        (invocation) => Future.value(),
      );
    },
  );

  group(
    'test localisation',
    () {
      testWidgets(
        'test en',
        (widgetTester) async {
          const Widget widget = LoginScreen();

          when(
            () => localeBloc.state,
          ).thenAnswer(
            (_) => const LocaleChanged(Locale("en")),
          );

          await widgetTester.wrapAndPump(widget, bloc: localeBloc);

          expect(find.text('Login'), findsOneWidget);
        },
      );

      testWidgets(
        'test vi',
        (widgetTester) async {
          const Widget widget = LoginScreen();

          when(
            () => localeBloc.state,
          ).thenAnswer(
            (_) => const LocaleChanged(Locale("vi")),
          );

          await widgetTester.wrapAndPump(widget, bloc: localeBloc);

          expect(find.text('Đăng nhập'), findsOneWidget);
        },
      );
    },
  );
}
