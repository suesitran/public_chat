import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/chat/ui/chat_screen.dart';
import 'package:public_chat/features/country/country.dart';
import 'package:public_chat/features/login/bloc/login_cubit.dart';
import 'package:public_chat/features/login/ui/widgets/sign_in_button.dart';
import 'package:public_chat/utils/functions_alert_dialog.dart';
import 'package:public_chat/utils/helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    required this.currentCountryCode,
    required this.currentLanguageCode,
  });

  final String currentCountryCode;
  final String currentLanguageCode;

  void _handleActionLoginSuccess(BuildContext context) {
    FunctionsAlertDialog.showAlertFlushBar(
      context,
      Helper.getTextTranslated(
        'loginSuccessMessage',
        currentLanguageCode,
      ),
      true,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            context.read<LoginCubit>().checkCountryCodeLocalExisted()
                ? ChatScreen(
                    currentCountryCode: currentCountryCode,
                    currentLanguageCode: currentLanguageCode,
                  )
                : CountryScreen(
                    currentCountryCode: currentCountryCode,
                    currentLanguageCode: currentLanguageCode,
                  ),
      ),
    );
  }

  void _handleActionLoginFailure(BuildContext context) {
    FunctionsAlertDialog.showAlertFlushBar(
      context,
      Helper.getTextTranslated(
        'loginFailMessage',
        currentLanguageCode,
      ),
      false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current is LoginLoading ||
          current is LoginSuccess ||
          current is LoginFailed,
      listener: (context, state) async {
        if (state is LoginLoading) {
          await FunctionsAlertDialog.showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
        }
        if (state is LoginSuccess && context.mounted) {
          _handleActionLoginSuccess(context);
        }
        if (state is LoginFailed && context.mounted) {
          _handleActionLoginFailure(context);
        }
      },
      child: Scaffold(
        body: Center(
          child: buildSignInButton(
            label: Helper.getTextTranslated(
              'loginTitle',
              currentLanguageCode,
            ),
            onPressed: () => context.read<LoginCubit>().requestLogin(),
          ),
        ),
      ),
    );
  }
}
