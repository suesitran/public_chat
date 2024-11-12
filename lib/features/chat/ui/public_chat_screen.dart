import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/features/chat/bloc/chat_cubit.dart';
import 'package:public_chat/utils/locale_support.dart';
import '../../../_shared/bloc/user_manager/user_manager_cubit.dart';
import '../../../_shared/dialog/loading_dialog.dart';
import '../../../_shared/widgets/chat_bubble_widget.dart';
import '../../../_shared/widgets/message_box_widget.dart';
import '../../app_settings/widgets/settings_button.dart';
import '../../translate_settings/widgets/translate_settings_button.dart';

class PublicChatScreen extends StatefulWidget {
  const PublicChatScreen({super.key});

  @override
  State<PublicChatScreen> createState() => _PublicChatScreenState();
}

class _PublicChatScreenState extends State<PublicChatScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    print('build PublicChatScreen:${user?.displayName}');
    return BlocProvider<ChatCubit>(
      create: (context) => ChatCubit(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(context.locale.publicRoomTitle),
            actions: const [TranslateSettingsButton(), SettingsButton()],
          ),
          body: Column(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    return FirestoreListView<Message>(
                        query: context.read<ChatCubit>().chatContent,
                        reverse: true,
                        pageSize: 10,
                        showFetchingIndicator: true,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context,
                            QueryDocumentSnapshot<Message> doc) {
                          print(
                              'build FirestoreListView:${doc.data().toString()}');
                          if (!doc.exists) {
                            return const SizedBox.shrink();
                          }
                          final Message message = doc.data();
                          // return SizedBox(
                          //     height: 200, child: Text(message.toString()));
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

                                return ChatBubble(
                                    isMine: message.sender == user?.uid,
                                    message: message.message,
                                    photoUrl: photoUrl,
                                    displayName: displayName,
                                    translations: message.translations,
                                    id: doc.id);
                              },
                            ),
                          );
                        },
                        fetchingIndicatorBuilder: (context) =>
                            const LoadingState(),
                        emptyBuilder: (context) => const Center(
                              child: Text(
                                  'No messages found. Send the first message now!'),
                            ),
                        loadingBuilder: (context) => const LoadingState());
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Đè tin nhắn để hiện tùy chọn'),
                  MessageBox(
                    onSendMessage: (value) {
                      if (user == null) {
                        // do nothing
                        return;
                      }
                      final msg = Message(sender: user.uid, message: value);
                      FirebaseFirestore.instance
                          .collection('public')
                          .add(msg.toMap());
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }
}
