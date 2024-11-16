import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:public_chat/_shared/bloc/languages/language_cubit.dart';

extension LocaleSupport on BuildContext {
  AppLocalizations get locale {
    AppLocalizations? locale = AppLocalizations.of(this);

    if (locale == null) {
      throw Exception('Locale is requested before Localisation initalised');
    }

    return locale;
  }

  LanguageCubit get languageCubit => read<LanguageCubit>();
}
