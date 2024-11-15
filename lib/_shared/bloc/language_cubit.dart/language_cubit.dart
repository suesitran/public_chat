import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/data/language.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/bloc_extensions.dart';
import 'package:public_chat/utils/locale_support.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState());

  void init(BuildContext context) {
    setAppLanguage(Language.fromMapping(code: context.locale.localeName));
  }

  void setAppLanguage(Language language) {
    emitSafely(state.copyWith(appLanguage: language));
  }

  void setMessageLanguage(Language? language, {bool saveToDatabase = true}) {
    if (saveToDatabase) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final database = ServiceLocator.instance.get<Database>();
        database.saveUser(user, language);
        if (language != null) database.addLanguage(language);
      }
    }

    emitSafely(state.copyWith(messageLanguage: language));
  }
}
