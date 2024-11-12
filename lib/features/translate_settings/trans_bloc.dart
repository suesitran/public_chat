import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/utils/bloc_extensions.dart';
import 'package:public_chat/utils/local_shared_data.dart';
part 'trans_event.dart';
part 'trans_state.dart';

class TransBloc extends Bloc<TransEvent, TransState> {
  final LocalSharedData _localSharedData = LocalSharedData();
  TransBloc() : super(TransInit()) {
    on<SelectLanguageEvent>(_onSelectLanguage);
    on<LoadHistoryLanguagesEvent>(_onLoadHistoryLanguages);
  }
  Future<void> _onSelectLanguage(
    SelectLanguageEvent event,
    Emitter<TransState> emit,
  ) async {
    _localSharedData.setChatLanguages(event.languages);
    emitSafely(
      ChangeLangState(
        selectedLanguages: event.languages,
      ),
    );
  }

  FutureOr<void> _onLoadHistoryLanguages(
      LoadHistoryLanguagesEvent event, Emitter<TransState> emit) {
    print('onLoadHistoryLanguages');
    emitSafely(TransInit());
    final listHistoryLanguages = _localSharedData.getListHistoryLanguages();
    emitSafely(
        LoadHistoryLanguages(listHistoryLanguages: listHistoryLanguages));
  }
}