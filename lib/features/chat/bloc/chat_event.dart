part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

class SendMessageEvent extends ChatEvent {
  final String uid;
  final String message;

  const SendMessageEvent({required this.uid, required this.message});

  @override
  List<Object> get props => [uid, message];
}

class TranslateMessageEvent extends ChatEvent {
  final Message message;
  // Callback results executed after translation completes
  final void Function(bool success) onComplete;

  const TranslateMessageEvent(
      {required this.message, required this.onComplete});

  @override
  List<Object> get props => [message, onComplete];
}
