import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

final class UserDetail {
  final String displayName;
  final String? photoUrl;
  final String uid;
  final String? language;

  UserDetail.fromFirebaseUser(User user, this.language)
      : displayName = user.displayName ?? 'Unknown',
        photoUrl = user.photoURL,
        uid = user.uid;

  UserDetail.fromMap(this.uid, Map<String, dynamic> map)
      : displayName = map['displayName'],
        language = map['language'],
        photoUrl = map['photoUrl'];

  Map<String, dynamic> toMap() =>
      {'displayName': displayName, 'photoUrl': photoUrl, 'language': language};
}
