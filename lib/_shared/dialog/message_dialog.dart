import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/routes/navigator.dart';
import '../../main.dart';

class MessageDialog {
  static void showMessageDialog({
    Widget? contentWidget,
    String? contentText,
    String? closeText = 'Close',
    List<Widget>? actions,
    bool tapOutsideToClose = false,
    Color? color,
    Widget? titleWidget,
    String? titleText,
    Function()? onTapClose,
    bool showCloseButton = true,
  }) {
    showCupertinoModalPopup<void>(
      context: globalAppContext!,
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
          actions: showCloseButton
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

  static void showError(
    String err, {
    Widget? contentWidget,
    String? closeText = 'Close',
    List<Widget>? actions,
    bool tapOutsideToClose = false,
    String? titleText,
  }) {
    showMessageDialog(
        color: Colors.red,
        contentText: err,
        titleWidget: Text(titleText ?? 'Error',
            style: const TextStyle(color: Colors.red, fontSize: 20)),
        contentWidget: contentWidget,
        closeText: closeText,
        actions: actions,
        tapOutsideToClose: tapOutsideToClose);
  }
}
