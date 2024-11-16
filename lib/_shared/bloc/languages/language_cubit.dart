import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit(super.initialState);

  void switchLanguage(Locale newLocale) {
    emitSafely(newLocale);
  }
}
