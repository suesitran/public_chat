import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:public_chat/features/chat/chat.dart';
import 'package:public_chat/features/country/country.dart';
import 'package:public_chat/features/language_load/cubit/language_load_cubit.dart';
import 'package:public_chat/features/login/login.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageLoadScreen extends StatefulWidget {
  const LanguageLoadScreen({super.key});

  @override
  State<LanguageLoadScreen> createState() => _LanguageLoadScreenState();
}

class _LanguageLoadScreenState extends State<LanguageLoadScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LanguageLoadCubit>().loadAllLanguageStatic();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LanguageLoadCubit, LanguageLoadState>(
      listenWhen: (previous, current) =>
          current == LanguageLoadState.success ||
          current == LanguageLoadState.failure,
      listener: (context, state) {
        final screen = FirebaseAuth.instance.currentUser != null
            ? (ServiceLocator.instance
                            .get<SharedPreferences>()
                            .get(Constants.prefCurrentCountryCode)
                            ?.toString() ??
                        '')
                    .isNotEmpty
                ? const ChatScreen()
                : const CountryScreen()
            : const LoginScreen();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: state == LanguageLoadState.inProgress
              ? const SpinKitCircle(color: Colors.grey, size: 36)
              : const SizedBox(),
        );
      },
    );
  }
}
