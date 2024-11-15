import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/localization_manager/localization_manager_cubit.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/_shared/widgets/chat_bubble_widget.dart';
import 'package:public_chat/_shared/widgets/language_button.dart';
import 'package:public_chat/_shared/widgets/message_box_widget.dart';
import 'package:public_chat/features/chat/bloc/chat_cubit.dart';
import 'package:public_chat/features/setting/setting_screen.dart';
import 'package:public_chat/utils/locale_support.dart';

class PublicChatScreen extends StatefulWidget {
  const PublicChatScreen({super.key});

  @override
  State<PublicChatScreen> createState() => _PublicChatScreenState();
}

class _PublicChatScreenState extends State<PublicChatScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late final LocalizationManagerCubit chatLanguageCubit;
  late final UserManagerCubit userManagerCubit;

  @override
  void initState() {
    super.initState();
    chatLanguageCubit = BlocProvider.of<LocalizationManagerCubit>(context);
    userManagerCubit = BlocProvider.of<UserManagerCubit>(context);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (userManagerCubit.state.chatLanguage == null) {
        _showChooseLanguageDialog();
      }
    });
  }

  void _showChooseLanguageDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.locale.welcome),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.locale.chatLanguageDialogMessage),
              const SizedBox(
                height: 10,
              ),
              Text(context.locale.selectLanguage),
              const SizedBox(
                height: 10,
              ),
              LanguageButton(
                flagHeight: 30,
                onClosedBottomSheet: () {
                  if (userManagerCubit.state.chatLanguage != null) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCubit>(
      create: (context) => ChatCubit(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(context.locale.publicRoomTitle),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ));
                },
                icon: const Icon(Icons.settings),
              )
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
                        return BlocProvider<UserManagerCubit>.value(
                          value: userManagerCubit,
                          child:
                              BlocBuilder<UserManagerCubit, UserManagerState>(
                            builder: (context, state) {
                              return ChatBubble(
                                id: message.id,
                                isMine: message.sender == user?.uid,
                                message: message.message,
                                photoUrl: message.senderPhotoUrl,
                                displayName: message.senderName,
                                translations: message.translations,
                                senderChatLanguage: message.senderLanguageCode,
                              );
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
              MessageBox(
                onSendMessage: (value) {
                  if (user == null) {
                    // do nothing
                    return;
                  }
                  if (value.isEmpty) return;
                  FirebaseFirestore.instance.collection('public').add(Message(
                        sender: user!.uid,
                        senderName: user!.displayName,
                        senderPhotoUrl: user!.photoURL,
                        message: value,
                        senderLanguageCode:
                            userManagerCubit.state.chatLanguage?.langCode ??
                                "en",
                      ).toMap());
                },
              )
            ],
          )),
    );
  }
}
