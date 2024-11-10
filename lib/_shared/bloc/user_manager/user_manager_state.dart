part of 'user_manager_cubit.dart';

abstract class UserManagerState extends Equatable {
  const UserManagerState();
}

class UserManagerInitial extends UserManagerState {
  @override
  List<Object> get props => [];
}

final class UserDetailState extends UserManagerState {
  final String uid;
  final String? photoUrl;
  final String? displayName;
  final String? userLanguage;

  const UserDetailState(
      {required this.uid,
      required this.photoUrl,
      required this.displayName,
      required this.userLanguage});

  @override
  List<Object?> get props => [uid, photoUrl, displayName, userLanguage];
}
