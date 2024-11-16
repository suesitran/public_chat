import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/_shared/widgets/chat/chat_bubble_widget.dart';
import 'package:public_chat/_shared/widgets/chat/message_box_widget.dart';
import 'package:public_chat/features/chat/bloc/chat_cubit.dart';
import 'package:public_chat/features/genai_setting/data/user_message_model.dart';
import 'package:public_chat/utils/locale_support.dart';

class PublicChatScreen extends StatelessWidget {
  const PublicChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    const iconSize = 24.0;
    return BlocProvider<ChatCubit>(
      create: (context) => ChatCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.locale.publicRoomTitle),
          actions: [
            PopupMenuButton<Locale>(
              initialValue: context.languageCubit.state,
              onSelected: (value) {
                context.languageCubit.switchLanguage(value);
              },
              icon: const Icon(Icons.language),
              itemBuilder: (BuildContext context) => const [
                PopupMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                PopupMenuItem(
                  value: Locale('vi'),
                  child: Text('Tiếng Việt'),
                ),
                PopupMenuItem(
                  value: Locale('ko'),
                  child: Text('한국어'),
                ),
                PopupMenuItem(
                  value: Locale('ja'),
                  child: Text('日本語'),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  return FirestoreListView<Message>(
                    query: context.read<ChatCubit>().chatContent,
                    reverse: true,
                    itemBuilder: (BuildContext context,
                        QueryDocumentSnapshot<Message> doc) {
                      if (!doc.exists) {
                        return const SizedBox.shrink();
                      }

                      final Message message = doc.data();
                      // in my opinion, all widget related to chat should be separated into a folder.
                      //for example: all widget of chat: lib/widgets/chat/
                      return ChatBubble(
                        user: user,
                        message: message,
                        iconSize: iconSize,
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
        ),
      ),
    );
  }
}
