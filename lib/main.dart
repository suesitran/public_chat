import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/language_cubit.dart/language_cubit.dart';
import 'package:public_chat/features/genai_setting/bloc/genai_bloc.dart';
import 'package:public_chat/features/login/ui/login_screen.dart';
// import 'package:public_chat/firebase_options.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ServiceLocator.instance.initialise();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GenaiBloc()),
      BlocProvider(create: (context) => LanguageCubit())
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      buildWhen: (previous, current) =>
          previous.appLanguage != current.appLanguage,
      builder: (context, state) {
        return MaterialApp(
            locale: state.appLanguage?.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const _Home());
      },
    );
  }
}

class _Home extends StatefulWidget {
  const _Home();

  @override
  State<_Home> createState() => __HomeWState();
}

class __HomeWState extends State<_Home> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<LanguageCubit>().init(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}
