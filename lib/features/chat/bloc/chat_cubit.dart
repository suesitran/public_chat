import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  // Use in case logged in && has country code in local
  String currentCountryCodeSelected = '';
  String currentLanguageCodeSelected = '';

  void getCurrentLanguageCodeSelected() {
    currentCountryCodeSelected = ServiceLocator.instance
            .get<SharedPreferences>()
            .get(Constants.prefCurrentCountryCode)
            ?.toString() ??
        '';
    currentLanguageCodeSelected = Constants.countries.firstWhere(
        (el) => el['country_code'] == currentCountryCodeSelected,
        orElse: () => Constants.countries.firstWhere((el) =>
            el['country_code'] ==
            Constants.countryCodeDefault))['language_code'];
  }

  Query<Message> get chatContent =>
      ServiceLocator.instance.get<Database>().getPublicChatContents<Message>(
            fromFireStore: (snapshot, options) {
              final message =
                  Message.fromMap(snapshot.id, snapshot.data() ?? {});
              return message;
            },
            toFireStore: (value, options) => value.toMap(),
          );

  void sendChat({required String uid, required String message}) {
    ServiceLocator.instance.get<Database>().writePublicMessage(
          Message(
            sender: uid,
            translations: {currentLanguageCodeSelected: message},
          ),
        );
  }

  String getMessageTranslated(Message message) {
    if (message.translations.keys.isNotEmpty) {
      if (message.translations.keys.contains(currentLanguageCodeSelected)) {
        return message.translations[currentLanguageCodeSelected]!;
      }
      return message.translations.values.first;
    }
    return '';
  }
}
