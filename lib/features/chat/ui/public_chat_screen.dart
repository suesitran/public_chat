import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/_shared/widgets/chat_bubble_widget.dart';
import 'package:public_chat/_shared/widgets/message_box_widget.dart';
import 'package:public_chat/features/chat/bloc/chat_bloc.dart';
import 'package:public_chat/features/language/bloc/language_bloc.dart';
import 'package:public_chat/features/language/ui/language_setting_screen.dart';
import 'package:public_chat/utils/locale_support.dart';

class PublicChatScreen extends StatelessWidget {
  const PublicChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    context.read<LanguageBloc>().add(LoadLanguageEvent());

    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(context.locale.publicRoomTitle),
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
                          child:
                          BlocBuilder<UserManagerCubit, UserManagerState>(
                            builder: (context, state) {
                              String? photoUrl;
                              String? displayName;

                              if (state is UserDetailState) {
                                photoUrl = state.photoUrl;
                                displayName = state.displayName;
                              }

                              // Handle tap action to trigger message translation
                              return ChatBubble(
                                  onChatBubbleTap: () => context.read<ChatBloc>().add(TranslateMessageEvent(message: message)),
                                  isMine: message.sender == user?.uid,
                                  message: message.message,
                                  photoUrl: photoUrl,
                                  displayName: displayName,
                                  translations: message.translations);
                            },
                          ),
                        );
                      },
                      emptyBuilder: (context) => const Center(
                        child: Text(
                          'No messages found. Send the first message now!'),
                      ),
                      loadingBuilder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 5,),
              const Text('Click on the message to translate it into your language.'),
              MessageBox(
                onSendMessage: (value) {
                  if (user == null) {
                    // do nothing
                    return;
                  }
                  FirebaseFirestore.instance
                      .collection('public')
                      .add(Message(sender: user.uid, message: value).toMap());
                },
              )
            ],
          )),
    );
  }
}
