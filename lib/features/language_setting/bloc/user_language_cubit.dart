import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

class UserLanguageCubit extends Cubit<String> {
  StreamSubscription<String>? _userLanguageListen;
  UserLanguageCubit() : super('en');

  void startListen() {
    _userLanguageListen = Database.instance.listenLanguageSettingUser()?.listen(
      (event) {
        emitSafely(event);
      },
    );
  }

  @override
  Future<void> close() {
    _userLanguageListen?.cancel();
    _userLanguageListen = null;
    return super.close();
  }
}
