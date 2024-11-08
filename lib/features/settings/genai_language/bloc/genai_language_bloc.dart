import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'genai_language_event.dart';
part 'genai_language_state.dart';

class GenaiLanguageBloc extends Bloc<GenaiLanguageEvent, GenaiLanguageState> {
  GenaiLanguageBloc() : super(GenaiLanguageInitial()) {
    on<GenaiLoadLanguageEvent>(_onLoadLanguage);
    on<GenaiChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(
    GenaiLoadLanguageEvent event,
    Emitter<GenaiLanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString('genai_language');
    emitSafely(GenaiLanguageChanged(language: language));
  }

  Future<void> _onChangeLanguage(
    GenaiChangeLanguageEvent event,
    Emitter<GenaiLanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    if (event.language == null) {
      await prefs.remove('genai_language');
    } else {
      await prefs.setString('genai_language', event.language!);
    }
    emitSafely(GenaiLanguageChanged(language: event.language));
  }
}
