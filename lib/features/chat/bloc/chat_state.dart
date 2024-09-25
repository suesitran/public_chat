part of 'chat_cubit.dart';

final class ChatState extends Equatable {
  final Map<String, String?> userPhotos;
  const ChatState(this.userPhotos);

  @override
  List<Object?> get props => [...userPhotos.keys, ...userPhotos.values];
}