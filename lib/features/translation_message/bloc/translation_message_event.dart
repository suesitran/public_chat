part of 'translation_message_bloc.dart';

abstract class TranslationMessageEvent extends Equatable {
  const TranslationMessageEvent();

  @override
  List<Object?> get props => [];
}

class TranslateMessageRequested extends TranslationMessageEvent {
  final String messageId;
  final String message;

  const TranslateMessageRequested({
    required this.messageId,
    required this.message,
  });

  @override
  List<Object?> get props => [messageId, message];
}

class TranslationLanguageChanged extends TranslationMessageEvent {
  final TranslationLanguage language;

  const TranslationLanguageChanged(this.language);

  @override
  List<Object?> get props => [language];
}

class ToggleTranslationVisibility extends TranslationMessageEvent {
  final String messageId;

  const ToggleTranslationVisibility(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
