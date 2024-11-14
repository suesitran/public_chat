part of 'trans_bloc.dart';

abstract class TransEvent {}

class SelectLanguageEvent extends TransEvent {
  final List<String> languages;
  // final String message;
  // final String messageID;
  SelectLanguageEvent({
    required this.languages,
    // required this.message,
    // required this.messageID
  });
}

class LoadHistoryLanguagesEvent extends TransEvent {}
