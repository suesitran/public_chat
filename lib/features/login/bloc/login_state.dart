part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final String displayName;
  final String languageCode;

  const LoginSuccess(this.displayName, this.languageCode);

  @override
  List<Object?> get props => [displayName, languageCode];
}

class LoginFailed extends LoginState {
  final String reason;

  const LoginFailed(this.reason);

  @override
  List<Object?> get props => [reason];
}
