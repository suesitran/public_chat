import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/language_setting/bloc/language_setting_cubit.dart';
import 'package:public_chat/features/language_support/bloc/language_support_cubit.dart';
import 'package:public_chat/features/language_support/data/language.dart';

extension GetLanguageSupport on BuildContext {
  LanguageSupport languageUserObject(String language) {
    var languageUser = read<LanguageSupportCubit>().state.firstWhere(
          (element) => element == LanguageSupport(code: language),
        );
    return languageUser;
  }

  LanguageSupport get languageTempUser {
    var languageTempUser = read<LanguageSettingCubit>().state;
    return LanguageSupport(code: languageTempUser);
  }
}
