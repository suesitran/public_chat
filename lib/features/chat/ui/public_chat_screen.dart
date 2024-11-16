import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/_shared/widgets/chat_bubble_widget.dart';
import 'package:public_chat/_shared/widgets/message_box_widget.dart';
import 'package:public_chat/constants/app_texts.dart';
import 'package:public_chat/features/chat/bloc/chat_bloc.dart';
import 'package:public_chat/features/language/bloc/language_bloc.dart';
import 'package:public_chat/features/language/ui/language_setting_screen.dart';

class PublicChatScreen extends StatefulWidget {
  const PublicChatScreen({super.key});

  @override
  State<PublicChatScreen> createState() => _PublicChatScreenState();
}

class _PublicChatScreenState extends State<PublicChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LanguageBloc>().add(LoadLanguageEvent());
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        // wait for language setting to complete
        if (State is LanguageInitial || State is LanguageUpdating) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(),
            child: Scaffold(
              appBar: AppBar(
                // Update chat appbar title with user's language
                title: Text(
                    languageState.textApp.containsKey(AppTexts.chatTitle)
                        ? languageState.textApp[AppTexts.chatTitle]
                        : AppTexts.chatTitle),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.language),
                    onPressed: () {
                      // Navigate to the Language Setting Screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LanguageSettingScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        return FirestoreListView<Message>(
                          query: context.read<ChatBloc>().chatContent,
                          reverse: true,
                          itemBuilder: (BuildContext context,
                              QueryDocumentSnapshot<Message> doc) {
                            if (!doc.exists) {
                              return const SizedBox.shrink();
                            }

                            final Message message = doc.data();

                            return BlocProvider<UserManagerCubit>.value(
                              value: UserManagerCubit()
                                ..queryUserDetail(message.sender),
                              child: BlocBuilder<UserManagerCubit,
                                  UserManagerState>(
                                builder: (context, state) {
                                  String? photoUrl;
                                  String? displayName;

                                  if (state is UserDetailState) {
                                    photoUrl = state.photoUrl;
                                    displayName = state.displayName;
                                  }

                                  // Handle tap action to trigger message translation
                                  return ChatBubble(
                                      onChatBubbleTap: () async {
                                        final chatBloc =
                                            context.read<ChatBloc>();
                                        // Create a Completer to handle the result of the translation
                                        final completer = Completer<bool>();

                                        // send TranslateMessageEvent with the message and a callback
                                        chatBloc.add(TranslateMessageEvent(
                                          message: message,
                                          onComplete: (success) =>
                                              completer.complete(success),
                                        ));

                                        // Wait for the translation result
                                        return completer.future;
                                      },
                                      isMine: message.sender == user?.uid,
                                      message: message.message,
                                      photoUrl: photoUrl,
                                      displayName: displayName,
                                      translations: message.translations);
                                },
                              ),
                            );
                          },
                          emptyBuilder: (context) {
                            return Center(
                              child: Text(languageState.textApp
                                      .containsKey(AppTexts.noMessageFound)
                                  ? languageState
                                      .textApp[AppTexts.noMessageFound]
                                  : AppTexts.noMessageFound),
                            );
                          },
                          loadingBuilder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(languageState.textApp.containsKey(AppTexts.clickMessage)
                      ? languageState.textApp[AppTexts.clickMessage] +
                          ' ${languageState.languageName}.'
                      : '${AppTexts.clickMessage} ${languageState.languageName}.'),
                  MessageBox(
                    onSendMessage: (value) {
                      if (user == null) {
                        // do nothing
                        return;
                      }
                      FirebaseFirestore.instance.collection('public').add(
                          Message(sender: user.uid, message: value).toMap());
                    },
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
