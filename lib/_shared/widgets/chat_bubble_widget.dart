import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:public_chat/features/settings/chat_language/bloc/chat_language_bloc.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String? photoUrl;
  final String? displayName;
  final Map<String, dynamic> translations;

  final double _iconSize = 24.0;

  const ChatBubble({
    required this.isMine,
    required this.message,
    required this.photoUrl,
    required this.displayName,
    this.translations = const {},
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    // user avatar
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_iconSize),
          child: photoUrl == null
              ? const _DefaultPersonWidget()
              : ImageNetwork(
                  image: photoUrl!,
                  width: _iconSize,
                  height: _iconSize,
                  fitAndroidIos: BoxFit.fitWidth,
                  fitWeb: BoxFitWeb.contain,
                  onError: const _DefaultPersonWidget(),
                  onLoading: const _DefaultPersonWidget()),
        ),
      ),
    );

    // message bubble
    widgets.add(
      Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: isMine ? Colors.black26 : Colors.black87,
        ),
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<ChatLanguageBloc, ChatLanguageState>(
          builder: (context, state) => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // display name
              Text(
                displayName ?? 'Unknown',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isMine ? Colors.black87 : Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              // original language
              Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              // Show only translated languages in selected chat language
              if (translations.isNotEmpty && state is ChatLanguageChanged)
                ...translations.entries
                    .where(
                      (element) => element.key == state.selectedLanguage.code,
                    )
                    .map(
                      (e) => Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: '${e.key} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isMine
                                          ? Colors.black87
                                          : Colors.grey)),
                          TextSpan(
                            text: e.value,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color:
                                        isMine ? Colors.black87 : Colors.grey),
                          )
                        ]),
                        textAlign: isMine ? TextAlign.right : TextAlign.left,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: isMine ? widgets.reversed.toList() : widgets,
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
