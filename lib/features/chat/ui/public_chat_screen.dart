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
    final User? user = FirebaseAuth.instance.currentUser;

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
                    .orderBy('time', descending: true)
                    .withConverter(
                      fromFirestore: (snapshot, options) =>
                          Message.fromMap(snapshot.id, snapshot.data() ?? {}),
                      toFirestore: (value, options) => value.toMap(),
                    ),
                reverse: true,
                itemBuilder:
                    (BuildContext context, QueryDocumentSnapshot<Message> doc) {
                  if (!doc.exists) {
                    return const SizedBox.shrink();
                  }

                  final Message message = doc.data();

                  return ChatBubble(
                      isMine: message.sender == user?.uid,
                      photoUrl: user?.photoURL,
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
        ));
  }
}
