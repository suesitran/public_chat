import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/login/bloc/login_cubit.dart';
import 'package:public_chat/features/login/ui/widgets/sign_in_button.dart';
import 'package:public_chat/utils/locale_support.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(),
        child: const _LoginScreenBody(),
      );
}

class _LoginScreenBody extends StatelessWidget {
  const _LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state is LoginSuccess) {
            return Text('Hello ${state.displayName}');
          }

          if (state is LoginFailed) {
            return Column(
              children: [
                Text('Login failed. Try again'),
                buildSignInButton(label: context.locale.login, onPressed: () => context.read<LoginCubit>().requestLogin(),)
              ],
            );
          }

          return buildSignInButton(label: context.locale.login, onPressed: () => context.read<LoginCubit>().requestLogin(),);

        },
      )
    ),
  );
}
