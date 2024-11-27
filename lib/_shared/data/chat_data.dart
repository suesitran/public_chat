import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final class Message {
  final String id;
  final String sender;
  final Timestamp timestamp;
  final Map<String, dynamic> translations;

  Message({required this.sender, required this.translations})
      : id = '',
        timestamp = Timestamp.now();

  Message.fromMap(this.id, Map<String, dynamic> map)
      : sender = map['sender'],
        timestamp = map['time'],
        translations = map['translated'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> toMap() =>
      {'sender': sender, 'time': timestamp, 'translated': translations};
}

final class UserDetail {
  final String displayName;
  final String? photoUrl;
  final String uid;

  UserDetail.fromFirebaseUser(User user)
      : displayName = user.displayName ?? 'Unknown',
        photoUrl = user.photoURL,
        uid = user.uid;

  UserDetail.fromMap(this.uid, Map<String, dynamic> map)
      : displayName = map['displayName'],
        photoUrl = map['photoUrl'];

  Map<String, dynamic> toMap() =>
      {'displayName': displayName, 'photoUrl': photoUrl};
}
