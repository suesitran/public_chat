import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/bloc_extensions.dart';
import 'package:public_chat/utils/local_shared_data.dart';
part 'translate_message_event.dart';
part 'translate_message_state.dart';

class TranslateMessageBloc
    extends Bloc<TranslateMessageEvent, TranslateMessageState> {
  final LocalSharedData _localSharedData = LocalSharedData();
  TranslateMessageBloc() : super(TranslateMessageInit()) {
    on<EnableTranslateEvent>(_onSelectLanguage);
    on<LoadHistoryLanguagesEvent>(_onLoadHistoryLanguages);
  }
  Future<void> _onSelectLanguage(
    EnableTranslateEvent event,
    Emitter<TranslateMessageState> emit,
  ) async {
    ServiceLocator.instance.get<Database>().addLanguage(event.languages.first);
    _localSharedData.setCurrentSelectedLanguages(event.languages);
    emitSafely(EnableTranslateState(
      selectedLanguages: event.languages,
    ));
  }

  FutureOr<void> _onLoadHistoryLanguages(
      LoadHistoryLanguagesEvent event, Emitter<TranslateMessageState> emit) {
    emitSafely(TranslateMessageInit());
    final listHistoryLanguages = _localSharedData.getCurrentSelectedLanguages();
    emitSafely(
        LoadHistoryLanguages(listHistoryLanguages: listHistoryLanguages));
  }
}
