import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/settings/locale/data/locale_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:public_chat/utils/bloc_extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'locale_event.dart';

part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleInitial(AppLocalizationsExt.defaultLocale)) {
    on<LoadLocaleEvent>(_onLoadLocale);
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  Future<void> _onLoadLocale(
    LoadLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language');
    if (languageCode != null && AppLocalizationsExt.isSupported(languageCode)) {
      emitSafely(LocaleChanged(Locale(languageCode)));
    }
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', event.locale.languageCode);
    emitSafely(LocaleChanged(event.locale));
  }
}

extension AppLocalizationsExt on AppLocalizations {
  static List<LocaleInfo> get supportedLocaleInfos =>
      AppLocalizations.supportedLocales
          .map(
            (locale) => LocaleInfo.from(languageCode: locale.languageCode),
          )
          .toList();

  static Locale get defaultLocale {
    // Default locale is English if supportedLocales isEmpty or supportedLocales
    // contain locale  English
    if (AppLocalizations.supportedLocales.isEmpty || isSupported("end")) {
      return const Locale("en");
    }

    // If not support English pick first local on supportedLocales
    return AppLocalizations.supportedLocales.first;
  }

  static bool isSupported(String languageCode) {
    return AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == languageCode,
    );
  }
}
