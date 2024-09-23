import 'package:cloud_firestore/cloud_firestore.dart';

final class Message {
  final String id;
  final String message;
  final String sender;
  final Timestamp timestamp;

  Message({required this.message, required this.sender}) : id = '', timestamp = Timestamp.now();

  Message.fromMap(this.id, Map<String, dynamic> map)
      : message = map['message'] ?? '',
        sender = map['sender'],
        timestamp = map['time'];

  Map<String, dynamic> toMap() => {
    'message': message,
    'sender': sender,
    'time': timestamp
  };
}
