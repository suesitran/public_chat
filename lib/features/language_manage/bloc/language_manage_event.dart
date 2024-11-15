part of 'language_manage_bloc.dart';

sealed class LanguageManageEvent extends Equatable {
  const LanguageManageEvent();

  @override
  List<Object?> get props => [];
}

final class LanguageManageInit extends LanguageManageEvent {
  final bool isFetchMessageLanguage;
  final List<Locale> supportedLocales;
  final Language? appLanguage;
  final Language? messageLanguage;

  const LanguageManageInit({
    required this.isFetchMessageLanguage,
    required this.supportedLocales,
    required this.appLanguage,
    required this.messageLanguage,
  });

  @override
  List<Object?> get props =>
      [isFetchMessageLanguage, supportedLocales, appLanguage, messageLanguage];
}

final class LanguageManageSearch extends LanguageManageEvent {}

final class LanguageManageClearSearchText extends LanguageManageEvent {}

final class LanguageManageSearchTextChanged extends LanguageManageEvent {
  final String searchText;

  const LanguageManageSearchTextChanged({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}
