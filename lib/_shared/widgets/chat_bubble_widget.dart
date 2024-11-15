import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/features/chat/bloc/chat_cubit.dart';

class ChatBubble extends StatefulWidget {
  final bool isMine;
  final String message;
  final String id;
  final String? photoUrl;
  final String? displayName;
  final String? senderChatLanguage;
  final Map<String, dynamic> translations;

  const ChatBubble({
    super.key,
    required this.isMine,
    required this.message,
    required this.photoUrl,
    required this.displayName,
    this.translations = const {},
    this.senderChatLanguage,
    required this.id,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final double _iconSize = 24.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserManagerCubit userManagerCubit =
        BlocProvider.of<UserManagerCubit>(context);
    final userChatLanguageCode = userManagerCubit.state.chatLanguage?.langCode;
    final List<Widget> widgets = [];
    // user avatar
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_iconSize),
        child: widget.photoUrl == null
            ? const _DefaultPersonWidget()
            : ImageNetwork(
                image: widget.photoUrl!,
                width: _iconSize,
                height: _iconSize,
                fitAndroidIos: BoxFit.fitWidth,
                fitWeb: BoxFitWeb.contain,
                onError: const _DefaultPersonWidget(),
                onLoading: const _DefaultPersonWidget()),
      ),
    ));

    // message bubble
    widgets.add(Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: widget.isMine ? Colors.black26 : Colors.black87),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            widget.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // display name
          Text(
            widget.displayName ?? 'Unknown',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.isMine ? Colors.black87 : Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          // original language
          Text(
            widget.message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
          TranslationWidget(
            canTranslate: userChatLanguageCode != widget.senderChatLanguage,
            translation: widget.translations[userChatLanguageCode],
            isMine: widget.isMine,
            onShowTranslation: () async {
              if (widget.translations[userChatLanguageCode] == null) {
                await BlocProvider.of<ChatCubit>(context).getTranslation(
                  messageId: widget.id,
                  message: widget.message,
                  translations: widget.translations,
                  chatLanguage: userManagerCubit.state.chatLanguage,
                );
              }
            },
          ),
        ],
      ),
    ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: widget.isMine ? widgets.reversed.toList() : widgets,
      ),
    );
  }
}

class _DefaultPersonWidget extends StatelessWidget {
  const _DefaultPersonWidget();

  @override
  Widget build(BuildContext context) => const Icon(
        Icons.person,
        color: Colors.black,
        size: 20,
      );
}

class TranslationWidget extends StatefulWidget {
  final bool canTranslate;
  final String? translation;
  final bool isMine;
  final Function() onShowTranslation;

  const TranslationWidget(
      {super.key,
      required this.canTranslate,
      required this.translation,
      required this.isMine,
      required this.onShowTranslation});

  @override
  State<TranslationWidget> createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  bool isShowTranslation = false;
  bool isLoadingTranslation = false;

  @override
  Widget build(BuildContext context) {
    if (isLoadingTranslation) {
      return const SizedBox(
          width: 10, height: 10, child: CircularProgressIndicator());
    }
    return BlocConsumer<UserManagerCubit, UserManagerState>(
        builder: (BuildContext context, state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            widget.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (widget.canTranslate)
            InkWell(
              onTap: () async {
                if (!isShowTranslation) {
                  setState(() {
                    isLoadingTranslation = true;
                  });
                  await widget.onShowTranslation();
                }
                setState(() {
                  isShowTranslation = !isShowTranslation;
                  isLoadingTranslation = false;
                });
              },
              child: Text(
                isShowTranslation ? "Hide translation" : "Show translation",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: widget.isMine ? Colors.black54 : Colors.grey,
                    ),
              ),
            ),
          if (widget.translation != null && isShowTranslation)
            Text(
              widget.translation!.trim(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: widget.isMine ? Colors.black87 : Colors.grey,
                  ),
              textAlign: widget.isMine ? TextAlign.right : TextAlign.left,
            ),
        ],
      );
    }, listener: (BuildContext context, UserManagerState state) {
      setState(
        () {
          isShowTranslation = false;
        },
      );
    });
  }
}
