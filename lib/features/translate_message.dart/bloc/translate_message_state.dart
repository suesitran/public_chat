part of 'translate_message_bloc.dart';

abstract class TranslateMessageState {}

class TranslateMessageInit extends TranslateMessageState {
  TranslateMessageInit();
}

class TranslateMessageLoading extends TranslateMessageState {
  TranslateMessageLoading();
}

class TranslateMessageError extends TranslateMessageState {
  final String message;
  TranslateMessageError({
    required this.message,
  });
}

class EnableTranslateState extends TranslateMessageState {
  final List<String> selectedLanguages;
  EnableTranslateState({
    required this.selectedLanguages,
  });
}

class DisableTranslateState extends TranslateMessageState {
  DisableTranslateState();
}

class LoadHistoryLanguages extends TranslateMessageState {
  final List<String> listHistoryLanguages;
  LoadHistoryLanguages({required this.listHistoryLanguages});
}
