part of 'translate_message_bloc.dart';

abstract class TranslateMessageState extends Equatable {
  const TranslateMessageState();
}

class TranslateMessageInit extends TranslateMessageState {
  @override
  List<Object?> get props => [];
}

class TranslateMessageLoading extends TranslateMessageState {
  @override
  List<Object?> get props => [];
}

class TranslateMessageError extends TranslateMessageState {
  final String error;
  const TranslateMessageError(this.error);
  @override
  List<Object?> get props => [error];
}

class EnableTranslateState extends TranslateMessageState {
  final List<String> selectedLanguages;
  const EnableTranslateState({
    required this.selectedLanguages,
  });
  @override
  List<Object?> get props => [selectedLanguages, selectedLanguages.length, ...selectedLanguages];

  EnableTranslateState copyWith({
    List<String>? selectedLanguages,
  }) {
    return EnableTranslateState(
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
    );
  }
}

class DisableTranslateState extends TranslateMessageState {
  @override
  List<Object?> get props => [];
}

class LoadHistoryLanguages extends TranslateMessageState {
  final List<String> listHistoryLanguages;
  const LoadHistoryLanguages({required this.listHistoryLanguages});
  @override
  List<Object?> get props => [listHistoryLanguages];
}
