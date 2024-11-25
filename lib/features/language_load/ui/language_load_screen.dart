import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:public_chat/features/chat/chat.dart';
import 'package:public_chat/features/country/country.dart';
import 'package:public_chat/features/language_load/cubit/language_load_cubit.dart';
import 'package:public_chat/features/language_load/cubit/language_load_state.dart';
import 'package:public_chat/features/login/login.dart';

class LanguageLoadScreen extends StatefulWidget {
  const LanguageLoadScreen({super.key});

  @override
  State<LanguageLoadScreen> createState() => _LanguageLoadScreenState();
}

class _LanguageLoadScreenState extends State<LanguageLoadScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LanguageLoadCubit>().loadAllLanguageStatic(
          WidgetsBinding.instance.platformDispatcher.locale.countryCode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LanguageLoadCubit, LanguageLoadState>(
      listenWhen: (previous, current) => current is LanguageLoadSuccess,
      listener: (context, state) {
        if (state is LanguageLoadSuccess) {
          final currentCountryCode = state.countryCodeSelected;
          final languageCodeSelected = state.languageCodeSelected;
          final screen = FirebaseAuth.instance.currentUser != null
              ? currentCountryCode.isNotEmpty
                  ? ChatScreen(
                      currentCountryCode: currentCountryCode,
                      currentLanguageCode: languageCodeSelected,
                    )
                  : CountryScreen(
                      currentCountryCode: currentCountryCode,
                      currentLanguageCode: languageCodeSelected,
                    )
              : LoginScreen(
                  currentCountryCode: currentCountryCode,
                  currentLanguageCode: languageCodeSelected,
                );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: state is LanguageLoadInProgress
              ? const SpinKitCircle(color: Colors.grey, size: 36)
              : const SizedBox(),
        );
      },
    );
  }
}
