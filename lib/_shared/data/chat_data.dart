import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:public_chat/_shared/data/language.dart';

final class Message {
  final String id;
  final String message;
  final String sender;
  final Timestamp timestamp;
  final Map<String, dynamic> translations;

  Message({required this.message, required this.sender})
      : id = '',
        timestamp = Timestamp.now(),
        translations = {};

  Message.fromMap(this.id, Map<String, dynamic> map)
      : message = map['message'] ?? '',
        sender = map['sender'],
        timestamp = map['time'],
        translations = map['translated'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> toMap() =>
      {'message': message, 'sender': sender, 'time': timestamp};
}

final class UserDetail extends Equatable {
  final String displayName;
  final String? photoUrl;
  final String uid;
  final Language? messageLanguage;

  const UserDetail({
    required this.uid,
    required this.displayName,
    required this.photoUrl,
    required this.messageLanguage,
  });

  UserDetail.fromFirebaseUser(User user, [this.messageLanguage])
      : displayName = user.displayName ?? 'Unknown',
        photoUrl = user.photoURL,
        uid = user.uid;

  factory UserDetail.fromMap(String uid, Map<String, dynamic> map) {
    final messageLanguageData = map['messageLanguage'];

    return UserDetail(
      uid: uid,
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      messageLanguage: messageLanguageData is Map
          ? Language.fromMap(messageLanguageData)
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'displayName': displayName,
        'photoUrl': photoUrl,
        if (messageLanguage != null)
          'messageLanguage': messageLanguage!.toMap(importCountry: false)
      };

  @override
  List<Object?> get props => [displayName, photoUrl, uid, messageLanguage];
}
