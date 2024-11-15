part of 'localization_manager_cubit.dart';

class LocalizationManagerState extends Equatable {
  final Locale? locale;

  const LocalizationManagerState({
    this.locale,
  });

  @override
  List<Object?> get props => [locale];

  LocalizationManagerState copyWith({Locale? locale}) {
    return LocalizationManagerState(
      locale: locale ?? this.locale,
    );
  }
}
