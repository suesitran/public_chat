import 'package:flutter/material.dart';
import '../../../main.dart';

push(Widget page) {
  return navigatorKey.currentState
      ?.push(MaterialPageRoute(builder: (context) => page));
}

pushReplacement(Widget page) {
  return navigatorKey.currentState
      ?.pushReplacement(MaterialPageRoute(builder: (context) => page));
}

pop({dynamic arguments}) {
  navigatorKey.currentState?.pop(arguments ?? {});
}
