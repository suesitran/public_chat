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

  LoginSuccess(this.displayName);

  @override
  List<Object?> get props => [displayName];
}

class LoginFailed extends LoginState {
  final String reason;

  LoginFailed(this.reason);

  @override
  List<Object?> get props => [reason];
}