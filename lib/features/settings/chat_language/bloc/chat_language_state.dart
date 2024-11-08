part of 'chat_language_bloc.dart';

abstract class ChatLanguageState {}

class ChatLanguageInitializing extends ChatLanguageState {
  ChatLanguageInitializing();
}

class ChatLanguageError extends ChatLanguageState {
  ChatLanguageError();
}

class ChatLanguageChanged extends ChatLanguageState {
  final List<ChatLanguage> supportedLanguages;
  final ChatLanguage selectedLanguage;

  ChatLanguageChanged({
    required this.supportedLanguages,
    required this.selectedLanguage,
  });
}
