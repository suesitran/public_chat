import 'package:flutter/cupertino.dart';
import 'package:public_chat/main.dart';
import 'navigator.dart';

class LoadingDialog {
  static showLoading({BuildContext? context}) {
    showCupertinoDialog(
        context: globalAppContext ?? context!,
        builder: (context) {
          return const CupertinoAlertDialog(
            content: LoadingState(),
          );
        });
  }

  static hideLoading() {
    pop();
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CupertinoActivityIndicator());
  }
}
