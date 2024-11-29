import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final class Message {
  final String id;
  final String message;
  final String sender;
  final Timestamp timestamp;
  final String translationsNoStream;

  Message({required this.message, required this.sender})
      : id = '',
        timestamp = Timestamp.now(),
        translationsNoStream = '';

  Message.fromMap(this.id, Map<String, dynamic> map)
      : message = map['message'] ?? '',
        sender = map['sender'],
        timestamp = map['time'],
        translationsNoStream = map['translations_nostream'];

  Map<String, dynamic> toMap() => {
        'message': message,
        'sender': sender,
        'time': timestamp,
        'translations_nostream': translationsNoStream
      };
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
  @override
  String toString() => toMap().toString();
}