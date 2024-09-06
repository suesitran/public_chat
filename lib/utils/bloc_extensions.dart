// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocSafety<Event, State> on Bloc<Event, State> {
  void emitSafely(State state) {
    if (!isClosed) {
      emit(state);
    }
  }
}

extension CubitSafely<State> on Cubit<State> {
  void emitSafely(State state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
