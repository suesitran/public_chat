import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton(
      {super.key,
      required this.onPressed,
      required this.buttonName,
      this.textColor,
      this.backgroundColor,
      this.width,
      this.height});
  final String buttonName;
  final Function()? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          // fixedSize:MaterialStatePropertyAll(Size(width??,height)),
          // textStyle: MaterialStatePropertyAll(
          //   GoogleFonts.sarabun(
          //     color: textColor, fontWeight: FontWeight.bold, fontSize: 12)
          //     ),
          elevation: WidgetStateProperty.all(6),
          backgroundColor:
              WidgetStatePropertyAll(backgroundColor ?? Colors.transparent),
        ),
        onPressed: onPressed,
        child: Text(buttonName));
  }
}
