import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/chat/ui/public_chat_screen.dart';
import 'package:public_chat/features/country/country.dart';
import 'package:public_chat/features/login/bloc/login_cubit.dart';
import 'package:public_chat/features/login/ui/widgets/sign_in_button.dart';
import 'package:public_chat/utils/functions_alert_dialog.dart';
import 'package:public_chat/utils/locale_support.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          FunctionsAlertDialog.showAlertFlushBar(
            context,
            'Login successfully',
            true,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  context.read<LoginCubit>().checkCountryCodeLocalExisted()
                      ? const PublicChatScreen()
                      : const CountryScreen(),
            ),
          );
        }
        if (state is LoginFailed && context.mounted) {
          FunctionsAlertDialog.showAlertFlushBar(
            context,
            'Login failed. Try again',
            false,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: buildSignInButton(
            label: context.locale.login,
            onPressed: () => context.read<LoginCubit>().requestLogin(),
          ),
        ),
      ),
    );
  }
}
