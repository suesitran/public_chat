import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:public_chat/features/translation_message/data/translation_language.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'translation_message_event.dart';
part 'translation_message_state.dart';

class TranslationMessageBloc
    extends Bloc<TranslationMessageEvent, TranslationMessageState> {
  TranslationMessageBloc() : super(const TranslationMessageState()) {
    on<TranslationLanguageChanged>(_onLanguageChanged);
    on<TranslateMessageRequested>(_onTranslateMessage);
    on<ToggleTranslationVisibility>(_onToggleTranslationVisibility);
  }

  void _onLanguageChanged(
    TranslationLanguageChanged event,
    Emitter<TranslationMessageState> emit,
  ) {
    emitSafely(state.copyWith(
        selectedLanguage: event.language,
        // reset translations when language changes
        messagesInTranslation: {},
        status: TranslationStatus.initial,
        error: null,
        visibleTranslations: {}));
  }

  void _onToggleTranslationVisibility(
    ToggleTranslationVisibility event,
    Emitter<TranslationMessageState> emit,
  ) {
    final Set<String> newVisibleTranslations =
        Set.from(state.visibleTranslations);

    if (newVisibleTranslations.contains(event.messageId)) {
      newVisibleTranslations.remove(event.messageId);
    } else {
      newVisibleTranslations.add(event.messageId);
    }

    emit(state.copyWith(visibleTranslations: newVisibleTranslations));
  }

  Future<void> _onTranslateMessage(
    TranslateMessageRequested event,
    Emitter<TranslationMessageState> emit,
  ) async {
    if (state.selectedLanguage == null) return;

    emit(state.copyWith(
      messagesInTranslation: {...state.messagesInTranslation, event.messageId},
    ));

    try {
      await ServiceLocator.instance.get<Database>().translateMessage(
            messageId: event.messageId,
            message: event.message,
            targetLanguage: state.selectedLanguage!.code,
          );

      // After successful translation, make it visible
      final Set<String> newVisibleTranslations =
          Set.from(state.visibleTranslations)..add(event.messageId);

      emit(state.copyWith(
        messagesInTranslation: state.messagesInTranslation
            .where((id) => id != event.messageId)
            .toSet(),
        visibleTranslations: newVisibleTranslations,
      ));
    } catch (e) {
      emit(state.copyWith(
        messagesInTranslation: state.messagesInTranslation
            .where((id) => id != event.messageId)
            .toSet(),
        error: e.toString(),
      ));
    }
  }
}
