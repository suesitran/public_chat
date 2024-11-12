import 'local_shared_data.dart';

class Global {
  Global._internal();
  static final Global _instance = Global._internal();
  factory Global() => _instance;
  init() async {
    await LocalSharedData().init();
  }
}
