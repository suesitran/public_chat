import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/genai_setting/bloc/genai_bloc.dart';
import 'package:public_chat/features/settings/genai_language/bloc/genai_language_bloc.dart';
import 'package:public_chat/features/settings/locale/bloc/locale_bloc.dart';
import 'package:public_chat/features/login/ui/login_screen.dart';
import 'package:public_chat/firebase_options.dart';
import 'package:public_chat/repository/genai_model.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ServiceLocator.instance.initialise();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<GenaiBloc>(
        create: (context) => GenaiBloc(),
      ),
      BlocProvider<GenaiLanguageBloc>(
        create: (context) => GenaiLanguageBloc()..add(GenaiLoadLanguageEvent()),
      ),
      BlocProvider<LocaleBloc>(
        create: (context) => LocaleBloc()..add(LoadLocaleEvent()),
      ),
    ],
    child: BlocListener<GenaiLanguageBloc, GenaiLanguageState>(
      listener: (context, state) {
        ServiceLocator.instance.get<GenAiModel>().updateLanguage(
              language: state.language,
            );
      },
      child: const MainApp(),
    ),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: state.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LoginScreen(),
      ),
    );
  }
}
