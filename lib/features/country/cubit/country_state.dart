part of 'country_cubit.dart';

sealed class CountryState extends Equatable {
  const CountryState();
}

final class CountryInitial extends CountryState {
  @override
  List<Object> get props => [];
}

class CurrentCountryCodeSelected extends CountryState {
  const CurrentCountryCodeSelected({required this.countryCode});
  final String countryCode;

  @override
  List<Object> get props => [countryCode];
}

class TemporaryCountryCodeSelected extends CountryState {
  const TemporaryCountryCodeSelected({required this.countryCode});
  final String countryCode;

  @override
  List<Object> get props => [countryCode];
}

class CurrentLanguageCodeSelected extends CountryState {
  const CurrentLanguageCodeSelected({required this.languageCode});
  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}
