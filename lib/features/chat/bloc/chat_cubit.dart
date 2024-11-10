import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/countries.dart';

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

  String getCountryCodeFromLanguageCode(String languageCode) {
    return countries.firstWhere(
      (el) => el['language_code'] == languageCode,
      orElse: () => countries.first,
    )['country_code'];
  }

  String getCountryNameFromLanguageCode(String languageCode) {
    return countries.firstWhere(
      (el) => el['language_code'] == languageCode,
      orElse: () => countries.first,
    )['name'];
  }
}
