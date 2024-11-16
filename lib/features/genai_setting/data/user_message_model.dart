import 'package:equatable/equatable.dart';

class UserMessageModel extends Equatable {
  const UserMessageModel({
    required this.iconSize,
    required this.photoUrl,
    required this.translations,
    required this.displayName,
    required this.message,
    required this.messageId,
  });

  final String message;
  final String messageId;
  final String? displayName;
  final String? photoUrl;
  final double iconSize;
  final Map<String, dynamic> translations;

  String get name {
    return displayName ?? 'Unknown';
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [message, messageId, displayName, photoUrl, translations];
}
