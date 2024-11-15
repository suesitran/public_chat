part of 'language_manage_bloc.dart';

final class LanguageManageState extends Equatable {
  final LanguageFetchStatus status;
  final List<Language> appLanguages, messageLanguages, languagesFiltered;
  final String errorMessage, searchText;
  final Language? appLanguage;
  final Language? messageLanguage;

  const LanguageManageState({
    this.status = LanguageFetchStatus.initial,
    this.appLanguages = const [],
    this.messageLanguages = const [],
    this.languagesFiltered = const [],
    this.errorMessage = '',
    this.searchText = '',
    this.appLanguage,
    this.messageLanguage,
  });

  LanguageManageState copyWith({
    LanguageFetchStatus? status,
    List<Language>? appLanguages,
    List<Language>? messageLanguages,
    List<Language>? languagesFiltered,
    String? errorMessage,
    String? searchText,
    Language? appLanguage,
    Language? messageLanguage,
  }) =>
      LanguageManageState(
        status: status ?? this.status,
        appLanguages: appLanguages ?? this.appLanguages,
        messageLanguages: messageLanguages ?? this.messageLanguages,
        languagesFiltered: languagesFiltered ?? this.languagesFiltered,
        errorMessage: errorMessage ?? this.errorMessage,
        searchText: searchText ?? this.searchText,
        appLanguage: appLanguage ?? this.appLanguage,
        messageLanguage: messageLanguage ?? this.messageLanguage,
      );

  @override
  List<Object?> get props => [
        status,
        appLanguages,
        messageLanguages,
        languagesFiltered,
        errorMessage,
        searchText,
        appLanguage,
        messageLanguage,
      ];
}

enum LanguageFetchStatus { initial, success, failed }
