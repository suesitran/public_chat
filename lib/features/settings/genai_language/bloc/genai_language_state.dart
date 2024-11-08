part of 'genai_language_bloc.dart';

abstract class GenaiLanguageState {
  final String? language;

  const GenaiLanguageState({this.language});
}

class GenaiLanguageInitial extends GenaiLanguageState {
  GenaiLanguageInitial();
}

class GenaiLanguageChanged extends GenaiLanguageState {
  GenaiLanguageChanged({super.language});
}
