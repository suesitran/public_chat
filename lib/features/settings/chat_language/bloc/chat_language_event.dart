part of 'chat_language_bloc.dart';

abstract class ChatLanguageEvent {}

class ChatLoadLanguageEvent extends ChatLanguageEvent {}

class ChatChangeLanguageEvent extends ChatLanguageEvent {
  final ChatLanguage language;

  ChatChangeLanguageEvent(this.language);
}
