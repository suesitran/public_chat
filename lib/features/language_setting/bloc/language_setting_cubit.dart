import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:public_chat/features/language_support/data/language.dart';
import 'package:public_chat/repository/database.dart';

part 'language_setting_state.dart';

class LanguageSettingCubit extends Cubit<String> {
  LanguageSettingCubit(super.initialState);

  void chooseLanguage(LanguageSupport dataLanguage) {
    emit(dataLanguage.code ?? 'en');
  }

  void saveLanguage() {
    Database.instance.saveLanguageUser(state);
  }
}
