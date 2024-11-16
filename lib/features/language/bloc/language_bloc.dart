import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/data/language_support_data.dart';
import 'package:public_chat/constants/app_texts.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/repository/genai_model.dart';
import 'package:public_chat/repository/preferences_manager.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final GenAiModel model = ServiceLocator.instance.get<GenAiModel>();

  LanguageBloc() : super(LanguageInitial(defaultLanguage, {})) {
    on<LoadLanguageEvent>(_onLoadLanguage);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  // Handle language load event when login
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
        String languagePref = await PreferencesManager.instance.getLanguage();
        Map<String, String> textsApp =
            await PreferencesManager.instance.getAllAppText();

        // Check if user language matches firestore with pref
        // and appTextsUI is already in pref
        if (userLanguage == languagePref && textsApp.isNotEmpty) {
          // use data in pref
          emitSafely(LanguageLoaded(userLanguage, textsApp));
        } else {
          // Update new language to pref
          await PreferencesManager.instance.saveLanguage(userLanguage);

          // Get or create new appTextsUI
          Map<String, String> textsApp =
              await _fetchAndCacheTexts(userLanguage);

          emitSafely(LanguageLoaded(userLanguage, textsApp));
        }
      } else {
        // If no storage language, default is English
        emitSafely(LanguageLoaded(defaultLanguage, {}));
      }
    } else {
      emitSafely(LanguageLoaded(defaultLanguage, {}));
    }
  }

  // Handle language change event
  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String language = await PreferencesManager.instance.getLanguage();
      Map<String, String> textsApp =
          await PreferencesManager.instance.getAllAppText();

      // // Emit language updating status to loading
      emitSafely(LanguageUpdating(event.languageName, textsApp));

      // Check if the new language is different from the current language
      if (event.languageName != language) {
        // Update new language to Firestore
        await Database.instance
            .updateUserLanguage(user.uid, event.languageName);

        // Update new language to pref
        await PreferencesManager.instance.saveLanguage(event.languageName);

        Map<String, String> textsApp =
            await _fetchAndCacheTexts(event.languageName);

        emitSafely(LanguageUpdated(event.languageName, textsApp));
      } else {
        emitSafely(LanguageUpdated(event.languageName, textsApp));
      }
    }
  }

  // Function to convert text displayed in UI to user language
  Future<Map<String, String>> _fetchAndCacheTexts(String language) async {
    // if text displayed in UI of user language available on firestore -> get it
    Map<String, dynamic>? textsDataFirebase =
        await Database.instance.getTextDisplayApplication(language);

    // if not available on firestore -> create by FunctionCalls
    if (textsDataFirebase == null) {
      Map<String, String> textsData =
          await model.translateMessagesBatch(AppTexts.getAllTexts(), language);

      // save appTexts to Firestore
      await Database.instance.setTextDisplayApplication(language, textsData);

      // save appTexts to pref
      PreferencesManager.instance.saveAppText(textsData);

      return textsData;
    } else {
      // save appTexts to pref if has available on firestore
      PreferencesManager.instance.saveAppText(textsDataFirebase);
      return textsDataFirebase
          .map((key, value) => MapEntry(key, value.toString()));
    }
  }
}
