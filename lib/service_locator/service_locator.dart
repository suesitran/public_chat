import 'package:get_it/get_it.dart';
import 'package:public_chat/l10n/text_ui_static.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/repository/genai_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class ServiceLocator {
  static ServiceLocator instance = ServiceLocator._();

  final GetIt _getIt = GetIt.asNewInstance();

  ServiceLocator._();

  Future<void> initialise() async {
    registerSingletonIfNeeded(GenAiModel());
    registerSingletonIfNeeded(GoogleTranslator());
    registerSingletonIfNeeded(TextsUIStatic());
    registerSingletonIfNeeded(Database.instance);
    await _registerSharePreference();
  }

  void registerSingletonIfNeeded<T extends Object>(T instance) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerSingleton<T>(instance);
    }
  }

  Future<void> _registerSharePreference() async {
    final pref = await SharedPreferences.getInstance();
    _getIt.registerSingleton(pref);
  }

  void reset() => _getIt.reset();

  T get<T extends Object>() {
    return _getIt.get<T>();
  }
}
