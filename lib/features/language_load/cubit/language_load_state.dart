import 'package:equatable/equatable.dart';

sealed class LanguageLoadState extends Equatable {
  const LanguageLoadState();
}

final class LanguageLoadInitial extends LanguageLoadState {
  @override
  List<Object> get props => [];
}

class LanguageLoadInProgress extends LanguageLoadState {
  @override
  List<Object?> get props => [];
}

class LanguageLoadSuccess extends LanguageLoadState {
  const LanguageLoadSuccess({
    required this.countryCodeSelected,
    required this.languageCodeSelected,
  });

  final String countryCodeSelected;
  final String languageCodeSelected;

  @override
  List<Object> get props => [countryCodeSelected, languageCodeSelected];
}
