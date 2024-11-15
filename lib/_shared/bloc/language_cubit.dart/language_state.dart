part of 'language_cubit.dart';

final class LanguageState extends Equatable {
  final Language? appLanguage;
  final Language? messageLanguage;

  const LanguageState({
    this.appLanguage,
    this.messageLanguage,
  });

  LanguageState copyWith({
    Language? appLanguage,
    Language? messageLanguage,
  }) =>
      LanguageState(
          appLanguage: appLanguage ?? this.appLanguage,
          messageLanguage: messageLanguage ?? this.messageLanguage);

  @override
  List<Object?> get props => [appLanguage, messageLanguage];
}
