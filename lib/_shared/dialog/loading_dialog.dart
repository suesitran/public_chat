import 'package:flutter/cupertino.dart';
import '../../config/routes/navigator.dart';
import '../../main.dart';

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
    return const CupertinoActivityIndicator();
  }
}
