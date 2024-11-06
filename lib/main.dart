import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/change_language/change_language_bloc.dart';
import 'package:public_chat/_shared/bloc/change_language/change_language_event.dart';
import 'package:public_chat/_shared/bloc/change_language/change_language_state.dart';
import 'package:public_chat/features/genai_setting/bloc/genai_bloc.dart';
import 'package:public_chat/features/login/ui/login_screen.dart';
import 'package:public_chat/firebase_options.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ServiceLocator.instance.initialise();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<GenaiBloc>(create: (context) => GenaiBloc()),
      BlocProvider(create: (_) => ChangeLanguageBloc()..add(OnInitEvent()))
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeLanguageBloc, ChangeLanguageState>(
        builder: (context, state) {
      Locale? locale;
      if (state is ChangeState) {
        locale = state.locale;
      } else if (state is InitState) {
        locale = state.locale;
      }
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginScreen());
    });
  }
}
