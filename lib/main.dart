import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/features/chat/chat.dart';
import 'package:public_chat/features/country/country.dart';
import 'package:public_chat/features/genai_setting/bloc/genai_bloc.dart';
import 'package:public_chat/features/language_load/language_load.dart';
import 'package:public_chat/features/login/login.dart';
import 'package:public_chat/firebase_options.dart';
import 'package:public_chat/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ServiceLocator.instance.initialise();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageLoadCubit>(
          create: (context) => LanguageLoadCubit(),
        ),
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider<UserManagerCubit>(create: (context) => UserManagerCubit()),
        BlocProvider<GenaiBloc>(create: (context) => GenaiBloc()),
        BlocProvider<ChatCubit>(create: (context) => ChatCubit()),
        BlocProvider<CountryCubit>(create: (context) => CountryCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: false),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LanguageLoadScreen(),
        builder: (_, child) {
          ErrorWidget.builder = (_) {
            return Container(
              color: Colors.white,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 100),
                  SizedBox(height: 8),
                  Text(
                    'Error, Please try again!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            );
          };
          return child!;
        },
      ),
    );
  }
}
