import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:public_chat/features/login/ui/login_screen.dart';

import '../../../material_wrapper_extension.dart';

void main() {
  // not use localisation any more
  group(
    'test localisation',
    () {
      testWidgets(
        'test en',
        (widgetTester) async {
          const Widget widget = LoginScreen();

          await widgetTester.wrapAndPump(widget, locale: const Locale('en'));

          // expect(find.text('Login'), findsOneWidget);
        },
      );

      testWidgets(
        'test vi',
        (widgetTester) async {
          const Widget widget = LoginScreen();

          await widgetTester.wrapAndPump(widget, locale: const Locale('vi'));

          // expect(find.text('Đăng nhập'), findsOneWidget);
        },
      );
    },
  );
}
