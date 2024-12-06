import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:public_chat/features/chat/chat.dart';
import 'package:public_chat/features/country/country.dart';
import 'package:public_chat/features/genai_setting/bloc/genai_bloc.dart';
import 'package:public_chat/features/language_load/language_load.dart';
import 'package:public_chat/features/login/login.dart';
import 'package:public_chat/firebase_options.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:public_chat/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        BlocProvider<GenaiBloc>(create: (context) => GenaiBloc()),
        BlocProvider<ChatCubit>(create: (context) => ChatCubit()),
        BlocProvider<CountryCubit>(create: (context) => CountryCubit()),
      ],
      child: KeyboardDismissOnTap(
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
              String countryCode = ServiceLocator.instance
                      .get<SharedPreferences>()
                      .get(Constants.prefCurrentCountryCode)
                      ?.toString() ??
                  'US';
              return Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 100,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Helper.getTextTranslated(
                        'widgetErrorTitle',
                        Helper.getLanguageCodeByCountryCode(countryCode),
                      ),
                      style: const TextStyle(
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
      ),
    );
  }
}
