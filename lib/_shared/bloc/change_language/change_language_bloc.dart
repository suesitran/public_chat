import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/change_language/change_language_event.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_language_state.dart';

class ChangeLanguageBloc
    extends Bloc<ChangeLanguageEvent, ChangeLanguageState> {
  final pref = ServiceLocator.instance.get<SharedPreferences>();
  ChangeLanguageBloc() : super(EmptyState()) {
    on<OnInitEvent>(_onInit);
    on<OnChangeEvent>(_onChange);
  }

  void _onInit(OnInitEvent event, Emitter<ChangeLanguageState> emitter) {
    final languageCode = pref.getString('languageCode');
    if (languageCode != null) {
      emitter(InitState(Locale(languageCode)));
    }
  }

  void _onChange(OnChangeEvent event, Emitter<ChangeLanguageState> emitter) {
    pref.setString('languageCode', event.languageCode);
    emitter(ChangeState(Locale(event.languageCode)));
  }
}
