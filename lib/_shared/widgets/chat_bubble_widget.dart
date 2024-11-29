import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:public_chat/features/translate_message/bloc/translate_message_bloc.dart';
import 'package:public_chat/features/translate_message/widgets/translation_widget.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String? photoUrl;
  final String? displayName;
  final String? translationsNoStream;
  final String messageId;
  const ChatBubble({
    required this.messageId,
    required this.isMine,
    required this.message,
    required this.photoUrl,
    required this.displayName,
    required this.translationsNoStream,
    super.key,
  });

  final double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    // user avatar
    final List<Widget> widgets = [];
    widgets.add(Padding(
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
    ));

    // message bubble
    widgets.add(Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: isMine ? Colors.black26 : Colors.black87),
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TranslateMessageBloc, TranslateMessageState>(
            buildWhen: (previous, current) =>
                (current is EnableTranslateState &&
                    previous.props != current.props) ||
                current is DisableTranslateState,
            builder: (context, state) {
              return Column(
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
                  if (state is EnableTranslateState)
                    TranslationsWidget(
                      translationsNoStream: translationsNoStream,
                      subscription: ServiceLocator.instance
                          .get<Database>()
                          .getTranslationStream(messageId),
                      isMine: isMine,
                      selectedLanguages: state.props[0] as List<String>,
                    )
                ],
              );
            })));

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
