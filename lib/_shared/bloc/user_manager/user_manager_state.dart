part of 'user_manager_cubit.dart';

final class UserManagerState extends Equatable {
  final String? uid;
  final String? photoUrl;
  final String? displayName;
  final LanguageEntity? chatLanguage;

  const UserManagerState({
    this.uid,
    this.photoUrl,
    this.displayName,
    this.chatLanguage,
  });

  @override
  List<Object?> get props => [uid, photoUrl, displayName, chatLanguage];

  UserManagerState copyWith({
    String? uid,
    String? photoUrl,
    String? displayName,
    LanguageEntity? chatLanguage,
  }) {
    return UserManagerState(
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
      chatLanguage: chatLanguage ?? this.chatLanguage,
    );
  }
}
