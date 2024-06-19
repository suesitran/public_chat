import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'genai_state.dart';

class GenaiCubit extends Cubit<GenaiState> {
  GenaiCubit() : super(GenaiInitial());

  void sendToGemini(String message) {}
}
