part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final String displayName;

  const LoginSuccess(this.displayName);

  @override
  List<Object?> get props => [displayName];
}

class LoginFailed extends LoginState {
  final String reason;

  const LoginFailed(this.reason);

  @override
  List<Object?> get props => [reason];
}

class LogoutLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LogoutSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}

class LogoutFailed extends LoginState {
  final String reason;

  const LogoutFailed(this.reason);

  @override
  List<Object?> get props => [reason];
}
