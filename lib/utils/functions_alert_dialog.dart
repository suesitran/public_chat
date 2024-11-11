import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:public_chat/utils/app_extensions.dart';

class FunctionsAlertDialog {
  static Future<void> showLoadingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: 80),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitCircle(color: Colors.blue, size: 36),
              ],
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

  static Future<void> showNoticeAndConfirmDialog(
    BuildContext context, {
    String? title,
    String? description,
    String? titleButtonClose,
    String? titleButtonSubmit,
    Function? callBackClickClose,
    Function? callBackClickSubmit,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
          insetPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          content: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title.isNotNullAndNotEmpty)
                  Text(
                    title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (description.isNotNullAndNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    child: Text(
                      description!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (titleButtonClose.isNotNullAndNotEmpty)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            callBackClickClose?.call();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Text(
                              titleButtonClose!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (titleButtonClose.isNotNullAndNotEmpty &&
                        titleButtonSubmit.isNotNullAndNotEmpty)
                      const SizedBox(width: 8),
                    if (titleButtonSubmit.isNotNullAndNotEmpty)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => callBackClickSubmit?.call(),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Text(
                              titleButtonSubmit!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
