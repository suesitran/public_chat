import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:public_chat/models/entities/language_entity.dart';

final class Message {
  final String id;
  final String message;
  final String sender;
  final String? senderName;
  final String? senderPhotoUrl;
  final String? senderLanguageCode;
  final Timestamp timestamp;
  final Map<String, dynamic> translations;

  Message({
    required this.message,
    required this.sender,
    this.senderLanguageCode,
    this.senderName,
    this.senderPhotoUrl,
  })  : id = '',
        timestamp = Timestamp.now(),
        translations = {};

  Message.fromMap(this.id, Map<String, dynamic> map)
      : message = map['message'] ?? '',
        sender = map['sender'],
        senderName = map['senderName'],
        senderPhotoUrl = map['senderPhotoUrl'],
        senderLanguageCode = map['senderLanguageCode'],
        timestamp = map['time'],
        translations = map['translations'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> toMap() => {
        'message': message,
        'sender': sender,
        'senderName': senderName,
        'senderPhotoUrl': senderPhotoUrl,
        'senderLanguageCode': senderLanguageCode,
        'time': timestamp,
        'translations': translations,
      };
}

final class UserDetail {
  final String displayName;
  final String? photoUrl;
  final String uid;
  final LanguageEntity? chatLanguage;

  UserDetail({
    required this.displayName,
    required this.uid,
    this.chatLanguage,
    this.photoUrl,
  });

  UserDetail.fromFirebaseUser(User user)
      : displayName = user.displayName ?? 'Unknown',
        photoUrl = user.photoURL,
        uid = user.uid,
        chatLanguage = null;

  UserDetail.fromMap(this.uid, Map<String, dynamic> map)
      : displayName = map['displayName'],
        photoUrl = map['photoUrl'],
        chatLanguage = map['chatLanguage'] != null
            ? LanguageEntity.fromJson(map['chatLanguage'])
            : null;

  Map<String, dynamic> toMap() => {
        'displayName': displayName,
        'photoUrl': photoUrl,
        'chatLanguage': chatLanguage,
      };
}
