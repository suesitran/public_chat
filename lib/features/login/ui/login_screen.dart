import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/features/chat/ui/public_chat_screen.dart';
import 'package:public_chat/features/login/bloc/login_cubit.dart';
import 'package:public_chat/features/login/ui/widgets/sign_in_button.dart';
import 'package:public_chat/utils/locale_support.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(
            userManagerCubit: BlocProvider.of<UserManagerCubit>(context)),
        child: const _LoginScreenBody(),
      );
}

class _LoginScreenBody extends StatelessWidget {
  const _LoginScreenBody();

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
          final Widget content = state is LoginFailed
              ? Column(
                  children: [
                    const Text('Login failed. Try again'),
                    buildSignInButton(
                      label: context.locale.login,
                      onPressed: () =>
                          context.read<LoginCubit>().requestLogin(),
                    )
                  ],
                )
              : buildSignInButton(
                  label: context.locale.login,
                  onPressed: () => context.read<LoginCubit>().requestLogin(),
                );

          return Scaffold(
            body: Center(child: content),
          );
        },
      );
}
