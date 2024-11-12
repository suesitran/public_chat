part of 'trans_bloc.dart';

abstract class TransState {}

class TransInit extends TransState {
  TransInit();
}

class SelectLangError extends TransState {
  final String message;
  SelectLangError({
    required this.message,
  });
}

class ChangeLangState extends TransState {
  final List<String> selectedLanguages;

  ChangeLangState({
    required this.selectedLanguages,
  });
}

class LoadHistoryLanguages extends TransState {
  final List<String> listHistoryLanguages;
  LoadHistoryLanguages({required this.listHistoryLanguages});
}
