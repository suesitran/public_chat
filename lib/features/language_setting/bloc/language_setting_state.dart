part of 'language_setting_cubit.dart';

abstract class LanguageSettingState extends Equatable {
  const LanguageSettingState();
}

class LanguageSettingInitial extends LanguageSettingState {
  @override
  List<Object> get props => [];
}

class LanguageSettingSuccess extends LanguageSettingState {
  final String language;

  const LanguageSettingSuccess(this.language);

  @override
  List<Object?> get props => [language];
}

class LanguageSettingFailed extends LanguageSettingState {
  final String reason;

  const LanguageSettingFailed(this.reason);

  @override
  List<Object?> get props => [reason];
}
