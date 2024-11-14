part of 'trans_bloc.dart';

abstract class TransEvent {}

class SelectLanguageEvent extends TransEvent {
  final List<String> languages;

  SelectLanguageEvent(this.languages);
}

class LoadHistoryLanguagesEvent extends TransEvent {}
