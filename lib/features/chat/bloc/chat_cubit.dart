import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/models/entities/language_entity.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/repository/genai_model.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/utils.dart';

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

  Future<void> getTranslation({
    required String messageId,
    required String message,
    required Map<String, dynamic> translations,
    LanguageEntity? chatLanguage,
  }) async {
    final model = ServiceLocator.instance.get<GenAiModel>();
    final response =
        await model.sendMessage(Content.text(Utils.getTranslationPromtMessage(
      message: message,
      newLanguage: chatLanguage?.langEnglishName ?? "",
    )));
    final translatedMessage = response.text?.trim();
    translations.putIfAbsent(
      chatLanguage?.langCode ?? "",
      () => translatedMessage,
    );
    await ServiceLocator.instance
        .get<Database>()
        .updatePublicMessage(messageId, {"translations": translations});
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
