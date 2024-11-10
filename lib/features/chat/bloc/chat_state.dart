part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatState {}

final class MessagesUpdateState extends ChatState {
  final Map<String, String?> userPhotos;
  const MessagesUpdateState(this.userPhotos);

  @override
  List<Object?> get props => [...userPhotos.keys, ...userPhotos.values];
}
