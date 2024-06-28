import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension MaterialWrapperExtension on WidgetTester {
  Future<void> wrapAndPump(Widget widget) => pumpWidget(MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ));
}
