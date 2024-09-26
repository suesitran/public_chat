import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState({}));

  Query<Message> get chatContent =>
      ServiceLocator.instance.get<Database>().getPublicChatContents<Message>(
            fromFirestore: (snapshot, options) {
              final message =
                  Message.fromMap(snapshot.id, snapshot.data() ?? {});

              return message;
            },
            toFirestore: (value, options) => value.toMap(),
          );

  void sendChat({required String uid, required String message}) {
    ServiceLocator.instance
        .get<Database>()
        .writePublicMessage(Message(message: message, sender: uid));
  }
}

extension UserPhotoUrl on Message {
  Future<UserDetail?> get userDetail async {
    final DocumentSnapshot<UserDetail> snapshot =
        await ServiceLocator.instance.get<Database>().getUser(sender);

    if (!snapshot.exists) {
      return null;
    }

    final UserDetail? user = snapshot.data();
    if (user == null) {
      return null;
    }

    return user;
  }
}
