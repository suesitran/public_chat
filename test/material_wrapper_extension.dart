import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:public_chat/features/settings/locale/bloc/locale_bloc.dart';

extension MaterialWrapperExtension on WidgetTester {
  Future<void> wrapAndPump(Widget widget, {LocaleBloc? bloc}) => pumpWidget(
        BlocProvider<LocaleBloc>(
          create: (context) => bloc ?? LocaleBloc(),
          child: BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) => MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: state.locale,
              home: Scaffold(
                body: widget,
              ),
            ),
          ),
        ),
      );
}
