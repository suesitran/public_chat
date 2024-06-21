import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

enum Sender { user, gemini }

class ChatContent extends Equatable {
  final Sender sender;
  final ChatData message;

  const ChatContent.user(this.message) : sender = Sender.user;
  const ChatContent.gemini(this.message) : sender = Sender.gemini;

  @override
  List<Object?> get props => [sender, message];
}

abstract class ChatData extends Equatable {
  static ChatData text(String message) => TextData(message);
  static ChatData file(File file) => FileData(file);
  static ChatData memory(Uint8List data, DataType type) =>
      MemoryData(data, type);
}

class TextData extends ChatData {
  final String message;

  TextData(this.message);

  @override
  List<Object?> get props => [message];
}

class FileData extends ChatData {
  final File file;

  FileData(this.file);

  @override
  List<Object?> get props => [file.path, file.lengthSync(), file.existsSync()];
}

enum DataType { image, video }

class MemoryData extends ChatData {
  final Uint8List data;
  final DataType type;

  MemoryData(this.data, this.type);

  @override
  List<Object?> get props => [data.length, type];

  String get mimeType => switch (type) {
        DataType.image => 'image/*',
        DataType.video => 'video/*',
      };
}
