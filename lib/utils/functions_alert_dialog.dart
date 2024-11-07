import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FunctionsAlertDialog {
  static showDialogLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
                color: Colors.white70, borderRadius: BorderRadius.circular(8)),
            child: const CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 24,
            ),
          ),
        );
      },
    );
  }

  static void showAlertFlushBar(
    BuildContext context,
    String message,
    bool isSuccess,
  ) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        message: message,
        messageSize: 14,
        icon: Icon(
          isSuccess ? Icons.check_circle : Icons.warning,
          color: Colors.white,
          size: 30,
        ),
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 2),
        borderRadius: BorderRadius.circular(8),
        flushbarStyle: FlushbarStyle.GROUNDED,
      ).show(context);
    });
  }
}
