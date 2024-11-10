part of 'language_bloc.dart';

sealed class LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final String languageName;

  ChangeLanguageEvent(this.languageName);
}

class LoadLanguageEvent extends LanguageEvent {}
