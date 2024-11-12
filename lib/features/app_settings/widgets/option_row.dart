import 'package:flutter/material.dart';

Widget buildRowOption(
    {String textLeft = '',
    Widget? widgetLeft,
    required Widget right,
    bool level2 = false}) {
  return Padding(
    padding:
        EdgeInsets.only(left: level2 ? 20 : 10, right: 10, top: 8, bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: widgetLeft ??
              Text(
                textLeft,
                style: TextStyle(
                  fontSize: level2 ? 16 : 18,
                  color: level2 ? Colors.grey : null,
                ),
                // style: GoogleFonts.sarabun(
                //   fontSize: 18,
                //   fontWeight: FontWeight.bold,
                // ),
              ),
        ),
        SizedBox(width: 100, child: right)
      ],
    ),
  );
}
