import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navigator.dart';

class MyDialog {
  static void showMyDialog(
    BuildContext context, {
    Widget? contentWidget,
    String? contentText,
    String? closeText = 'Close',
    List<Widget>? actions,
    bool tapOutsideToClose = false,
    Color? color,
    Widget? titleWidget,
    String? titleText,
    Function()? onTapClose,
    bool showActions = true,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: tapOutsideToClose,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: titleWidget ??
              Text(
                titleText ?? '',
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
          content: Material(
            color: Colors.transparent,
            child: contentWidget ??
                Text(contentText ?? '',
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16)),
          ),
          actions: showActions
              ? actions ??
                  [
                    TextButton(
                        onPressed: onTapClose ??
                            () {
                              pop();
                            },
                        child: Text(closeText ?? 'OK'))
                  ]
              : [],
        );
      },
    );
  }
}
