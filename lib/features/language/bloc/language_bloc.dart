import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/data/language_support_data.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial(defaultLanguage)) {
    on<LoadLanguageEvent>(_onLoadLanguage);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(
    LoadLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get user info from the database using their UID
      final userDetail = await Database.instance.getUser(user.uid);
      final userLanguage = userDetail.data()?.userLanguage;

      // If the user has a stored language preference,
      // emit the LanguageUpdate state
      // else emit 'English' as the default language
      if (userLanguage != null) {
        emitSafely(LanguageUpdate(userLanguage));
      } else {
        emitSafely(LanguageUpdate(defaultLanguage));
      }
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update the user's language in Firestore
      await Database.instance.updateUserLanguage(user.uid, event.languageName);

      // Emit the updated language state
      emitSafely(LanguageUpdate(event.languageName));
    }
  }
}
