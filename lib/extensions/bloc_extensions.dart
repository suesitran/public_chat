import 'package:flutter_bloc/flutter_bloc.dart';

extension EmitSafely on Bloc {
  void emitSafely(dynamic state) {
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(state);
    }
  }
}

extension CubitEmitSafely on Cubit {
  void emitSafely(dynamic state) {
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      emit(state);
    }
  }
}
