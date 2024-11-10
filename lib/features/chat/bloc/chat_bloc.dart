import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/_shared/data/language_support_data.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/repository/genai_model.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GenAiModel _model = ServiceLocator.instance.get<GenAiModel>();
  final SharedPreferences prefs =
      ServiceLocator.instance.get<SharedPreferences>();

  ChatBloc() : super(ChatInitialState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<TranslateMessageEvent>(_onTranslateMessage);
  }

  // Fetch chat contents from Firestore as Query<Message>
  Query<Message> get chatContent =>
      ServiceLocator.instance.get<Database>().getPublicChatContents<Message>(
            fromFirestore: (snapshot, options) {
              final message =
                  Message.fromMap(snapshot.id, snapshot.data() ?? {});
              return message;
            },
            toFirestore: (value, options) => value.toMap(),
          );

  // Handle sending a message
  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) {
    // Write the message to Firestore
    ServiceLocator.instance
        .get<Database>()
        .writePublicMessage(Message(message: event.message, sender: event.uid));
  }

  // Handle translating a message by Function call
  Future<void> _onTranslateMessage(
      TranslateMessageEvent event, Emitter<ChatState> emit) async {
    final userLanguage = prefs.getString('userLanguage') ?? defaultLanguage;

    // If the message is already translated to the user's language,
    // no action is taken
    if (event.message.translations.containsKey(userLanguage)) {
      return;
    }

    try {
      // Send translation request to the AI model
      var response = await _model.sendMessage(Content.text(
          "Translate `${event.message.message}` into `$userLanguage` response me only message"));

      // Get functionCalls from the AI response
      final functionCalls = response.functionCalls.toList();
      if (functionCalls.isNotEmpty) {
        final functionCall = functionCalls.first;
        final result = switch (functionCall.name) {
          'translate' => await setTranslateValue(functionCall.args),
          _ => throw UnimplementedError(
              'Function not implemented: ${functionCall.name}')
        };

        // Send back the function response with the translation
        response = await _model.sendMessage(
          Content.functionResponse(functionCall.name, result),
        );
      }

      final String? translatedText = response.text;

      // If translation exists,
      // update the message with the translation
      if (translatedText != null) {
        final updatedMessage = MessageTranslate(
          id: event.message.id,
          translations: {
            userLanguage: translatedText,
          },
        );

        ServiceLocator.instance
            .get<Database>()
            .updateTranslatePublicMessage(updatedMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error translating message: $e");
      }
    }
  }

  // Mock API function to simulate translation invoke
  Future<Map<String, Object?>> setTranslateValue(
    Map<String, Object?> arguments,
  ) async =>
      {
        'message': arguments['message'],
        'targetLanguage': arguments['targetLanguage'],
      };
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
