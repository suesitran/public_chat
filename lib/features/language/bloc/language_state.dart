part of 'language_bloc.dart';

sealed class LanguageState {
  final String languageName;

  const LanguageState(this.languageName);
}

final class LanguageInitial extends LanguageState {
  LanguageInitial(super.languageName);
}

class LanguageUpdate extends LanguageState {
  LanguageUpdate(super.languageName);
}
