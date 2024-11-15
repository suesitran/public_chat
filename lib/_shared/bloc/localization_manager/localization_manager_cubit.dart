import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'localization_manager_state.dart';

class LocalizationManagerCubit extends Cubit<LocalizationManagerState> {
  LocalizationManagerCubit() : super(const LocalizationManagerState());

  final sharedPref = ServiceLocator.instance.get<SharedPreferences>();

  void loadSavedLocale() {
    final savedLocaleString = sharedPref.getString('locale') ?? 'en';
    final savedLocale = Locale.fromSubtags(languageCode: savedLocaleString);
    emit(state.copyWith(locale: savedLocale));
  }

  Future<void> changeUserChatLanguage(Locale? locale) async {
    if (locale == null) return;
    emit(state.copyWith(locale: locale));
    sharedPref.setString('locale', locale.languageCode);
  }
}
