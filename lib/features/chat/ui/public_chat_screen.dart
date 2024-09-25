import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/_shared/widgets/chat_bubble_widget.dart';
import 'package:public_chat/_shared/widgets/message_box_widget.dart';
import 'package:public_chat/utils/locale_support.dart';

class PublicChatScreen extends StatelessWidget {
  const PublicChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
        appBar: AppBar(
          title: Text(context.locale.publicRoomTitle),
        ),
        body: Column(
          children: [
            Expanded(
              child: FirestoreListView<Message>(
                query: FirebaseFirestore.instance
                    .collection('public')
                    .orderBy('time')
                    .withConverter(
                      fromFirestore: (snapshot, options) =>
                          Message.fromMap(snapshot.id, snapshot.data() ?? {}),
                      toFirestore: (value, options) => value.toMap(),
                    ),
                itemBuilder:
                    (BuildContext context, QueryDocumentSnapshot<Message> doc) {
                  if (!doc.exists) {
                    return const SizedBox.shrink();
                  }

                  final Message message = doc.data();

                  return ChatBubble(
                      isMine: message.sender == uid,
                      photoUrl: null,
                      message: message.message,
                      translations: message.translations);
                },
                emptyBuilder: (context) => const Center(
                  child: Text('No messages found. Send the first message now!'),
                ),
                loadingBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            MessageBox(
              onSendMessage: (value) {
                if (uid == null) {
                  // do nothing
                  return;
                }
                FirebaseFirestore.instance
                    .collection('public')
                    .add(Message(sender: uid, message: value).toMap());
              },
            )
          ],
        ));
  }
}
