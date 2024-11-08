import 'package:equatable/equatable.dart';

enum Sender { user, gemini }

class ChatContent extends Equatable {
  final Sender sender;
  final String message;
  final bool generating;

  const ChatContent.user(this.message)
      : sender = Sender.user,
        generating = false;

  const ChatContent.gemini(this.message, {this.generating = false})
      : sender = Sender.gemini;

  @override
  List<Object?> get props => [sender, message];
}
