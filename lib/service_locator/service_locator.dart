import 'package:get_it/get_it.dart';
import 'package:public_chat/repository/genai_model.dart';

class ServiceLocator {
  static ServiceLocator instance = ServiceLocator._();

  ServiceLocator._();

  void initialise() {
    if (!GetIt.instance.isRegistered<GenAiModel>()) {
      GetIt.instance.registerSingleton(GenAiModel());
    }
  }

  T get<T extends Object>() {
    return GetIt.instance.get<T>();
  }
}
