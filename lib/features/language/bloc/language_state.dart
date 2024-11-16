part of 'language_bloc.dart';

sealed class LanguageState {
  final String languageName;
  // text displayed in UI - AppTexts
  final Map<String, dynamic> textApp;

  const LanguageState(this.languageName, this.textApp);
}

final class LanguageInitial extends LanguageState {
  LanguageInitial(super.languageName, super.textApp);
}

final class LanguageLoaded extends LanguageState {
  LanguageLoaded(super.languageName, super.textApp);
}

class LanguageUpdating extends LanguageState {
  LanguageUpdating(super.languageName, super.textApp);
}

class LanguageUpdated extends LanguageState {
  LanguageUpdated(super.languageName, super.textApp);
}
