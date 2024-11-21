import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final class Message {
  final String id;
  final String message;
  final String sender;
  final Timestamp timestamp;
  final List<TranslationModel> translations;

  Message({required this.message, required this.sender})
      : id = '',
        timestamp = Timestamp.now(),
        translations = [];

  Message.fromMap(this.id, Map<String, dynamic> map)
      : message = map['message'] ?? '',
        sender = map['sender'],
        timestamp = map['time'],
        translations = (map['translated'] as List<Map<String, dynamic>>?)
                ?.map((e) => TranslationModel.fromMap(e))
                .toList() ??
            [];

  Map<String, dynamic> toMap() =>
      {'message': message, 'sender': sender, 'time': timestamp};
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

class TranslationModel {
  final String translation;
  final String code;
  final List<String> languages;
  TranslationModel(
      {required this.translation, required this.code, required this.languages});
  TranslationModel.fromMap(Map<String, dynamic> map)
      : translation = map['translation'],
        code = map['code'],
        languages = map['languages'] as List<String>? ?? [];
  Map<String, dynamic> toMap() =>
      {'translation': translation, 'code': code, 'languages': languages};
  @override
  String toString() {
    return toMap().toString();
  }
}
