part of 'genai_language_bloc.dart';

abstract class GenaiLanguageEvent {}

class GenaiChangeLanguageEvent extends GenaiLanguageEvent {
  final String? language;

  GenaiChangeLanguageEvent(this.language);
}

class GenaiLoadLanguageEvent extends GenaiLanguageEvent {}
