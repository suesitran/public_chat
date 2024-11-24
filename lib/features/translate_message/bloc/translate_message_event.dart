part of 'translate_message_bloc.dart';

abstract class TranslateMessageEvent {}

class EnableTranslateEvent extends TranslateMessageEvent {
  final List<String> languages;
  EnableTranslateEvent({
    required this.languages,
  });
}

class DisableTranslateEvent extends TranslateMessageEvent {
  DisableTranslateEvent();
}

class LoadHistoryLanguagesEvent extends TranslateMessageEvent {}
