import 'package:flutter/material.dart';

class MyTextStyle {
  static Text errorText(String text) {
    return Text(text,
        style: const TextStyle(
            color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold));
  }

  Text noElement(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  static const translate =
      TextStyle(fontSize: 16, color: Colors.amber, fontStyle: FontStyle.italic);
  static const greySemiBold = TextStyle(
    color: Color.fromRGBO(179, 179, 179, 100),
    fontWeight: FontWeight.w600,
    fontSize: 14, //11,
  );

  static const titleAppbar = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  // static const inboxTextBlack = TextStyle(
  //   color: Colors.black,
  //   fontWeight: FontWeight.w500, //medium
  //   fontSize: 12,
  // );
  // static const inboxTextWhite = TextStyle(
  //   color: Colors.white.withOpacity(1),
  //   fontWeight: FontWeight.w400, //medium
  //   fontSize: 16,
  // );
  static const heading1 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const heading2 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  static const textSelected = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.2,
    backgroundColor: Colors.brown, //AppColor.backgroundText,
    decoration: TextDecoration.none,
  );
  static const normal = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.2,
    decoration: TextDecoration.none,
  );
}
