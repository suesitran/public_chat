import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/settings/chat_language/data/chat_language.dart';
import 'package:public_chat/features/settings/chat_language/service/chat_language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'chat_language_event.dart';
part 'chat_language_state.dart';

class ChatLanguageBloc extends Bloc<ChatLanguageEvent, ChatLanguageState> {
  List<ChatLanguage> _supportedLanguages = [];

  ChatLanguageBloc() : super(ChatLanguageInitializing()) {
    on<ChatLoadLanguageEvent>(_onLoadLanguage);
    on<ChatChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(
    ChatLoadLanguageEvent event,
    Emitter<ChatLanguageState> emit,
  ) async {
    emitSafely(ChatLanguageInitializing());

    try {
      _supportedLanguages = await ChatLanguageService.getSupportedLanguages();

      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('chat_language');

      final ChatLanguage selectedLanguage;
      if (language != null) {
        final savedLanguage = ChatLanguage.fromJson(
          jsonDecode(language),
        );
        // If save language not contain in supportedLanguages
        // defaultLanguage will be use
        if (_supportedLanguages.any((l) => l.code == savedLanguage.code)) {
          selectedLanguage = savedLanguage;
        } else {
          selectedLanguage = ChatLanguage.defaultLanguage();
        }
      } else {
        // If don't has save language, use Platform languageCode to find in supportedLanguages
        // defaultLanguage will be use if not find any language from Platform languageCode
        final String languageCode =
            ui.PlatformDispatcher.instance.locale.languageCode;

        selectedLanguage = _supportedLanguages.firstWhere(
          (c) => c.code == languageCode,
          orElse: () => ChatLanguage.defaultLanguage(),
        );
      }

      emitSafely(
        ChatLanguageChanged(
          supportedLanguages: _supportedLanguages,
          selectedLanguage: selectedLanguage,
        ),
      );
    } catch (e) {
      emitSafely(ChatLanguageError());
    }
  }

  Future<void> _onChangeLanguage(
    ChatChangeLanguageEvent event,
    Emitter<ChatLanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_language', event.language.toJsonString());

    emitSafely(
      ChatLanguageChanged(
        supportedLanguages: _supportedLanguages,
        selectedLanguage: event.language,
      ),
    );
  }
}
