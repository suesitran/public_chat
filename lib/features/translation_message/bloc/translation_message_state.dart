part of 'translation_message_bloc.dart';

enum TranslationStatus { initial, loading, success, failure }

class TranslationMessageState extends Equatable {
  final TranslationStatus status;
  final TranslationLanguage? selectedLanguage;
  final Set<String> messagesInTranslation;
  final String? error;
  final Set<String> visibleTranslations;

  const TranslationMessageState({
    this.status = TranslationStatus.initial,
    this.selectedLanguage,
    this.messagesInTranslation = const {},
    this.error,
    this.visibleTranslations = const {},
  });

  TranslationMessageState copyWith({
    TranslationStatus? status,
    TranslationLanguage? selectedLanguage,
    Set<String>? messagesInTranslation,
    String? error,
    Set<String>? visibleTranslations,
  }) {
    return TranslationMessageState(
      status: status ?? this.status,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      messagesInTranslation:
          messagesInTranslation ?? this.messagesInTranslation,
      error: error ?? this.error,
      visibleTranslations: visibleTranslations ?? this.visibleTranslations,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedLanguage,
        messagesInTranslation,
        error,
        visibleTranslations,
      ];
}
