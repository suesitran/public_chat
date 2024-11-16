import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/constants/app_texts.dart';
import 'package:public_chat/features/chat/ui/public_chat_screen.dart';
import 'package:public_chat/features/login/bloc/login_cubit.dart';
import 'package:public_chat/features/login/ui/widgets/sign_in_button.dart';
import 'package:public_chat/repository/preferences_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(),
        child: const _LoginScreenBody(),
      );
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody();

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> {
  String loginButtonText = '';
  String loginErrorText = '';

  @override
  void initState() {
    super.initState();
    _initializeTexts();
  }

  // Use the language set at the previous login.
  // default is english
  Future<void> _initializeTexts() async {
    loginButtonText =
        await PreferencesManager.instance.getAppText(AppTexts.loginButton) ??
            AppTexts.loginButton;
    loginErrorText =
        await PreferencesManager.instance.getAppText(AppTexts.loginErrorText) ??
            AppTexts.loginErrorText;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // open public chat screen
            // use Navigator temporary, will be changed later
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PublicChatScreen(),
                ));
          }
        },
        builder: (context, state) {
          Text(loginErrorText);

          final Widget content = state is LoginFailed
              ? Column(
                  children: [
                    Text(loginErrorText),
                    buildSignInButton(
                      label: loginButtonText,
                      onPressed: () =>
                          context.read<LoginCubit>().requestLogin(),
                    )
                  ],
                )
              : buildSignInButton(
                  label: loginButtonText,
                  onPressed: () => context.read<LoginCubit>().requestLogin(),
                );

          return Scaffold(
            body: Center(child: content),
          );
        },
      );
}
