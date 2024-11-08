part of 'language_cubit.dart';

sealed class LanguageState extends Equatable {
  const LanguageState();
}

final class LanguageInitial extends LanguageState {
  @override
  List<Object> get props => [];
}

class CurrentLanguageSelected extends LanguageState {
  @override
  List<Object> get props => [];
}
