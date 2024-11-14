part of 'trans_bloc.dart';

abstract class TransState {}

class TransInit extends TransState {
  TransInit();
}

class TransLoading extends TransState {
  TransLoading();
}

class TransError extends TransState {
  final String message;
  TransError({
    required this.message,
  });
}

class ChangeLangState extends TransState {
  final List<String> selectedLanguages;
  // final Map<String, dynamic> resultTranslations;
  ChangeLangState({
    required this.selectedLanguages,
    // required this.resultTranslations,
  });
}

class TransResult extends TransState {
  final Map<String, dynamic> resultTranslations;
  TransResult({
    required this.resultTranslations,
  });
}

class LoadHistoryLanguages extends TransState {
  final List<String> listHistoryLanguages;
  LoadHistoryLanguages({required this.listHistoryLanguages});
}
