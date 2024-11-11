import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/database.dart';
import '../../../service_locator/service_locator.dart';
import '../data/language.dart';

class LanguageSupportCubit extends Cubit<List<LanguageSupport>> {
  LanguageSupportCubit() : super([]) {
    getLanguageSupport();
  }

  void getLanguageSupport() async {
    try {
      final List<LanguageSupport> languageSupport =
          await ServiceLocator.instance.get<Database>().getLanguage();
      emit(languageSupport);
    } catch (e) {
      print(e);
      emit([]);
    }
  }
}
