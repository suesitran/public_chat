import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/chat/bloc/chat_cubit.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String senderUid;
  final Map<String, dynamic> translations;

  final double _iconSize = 24.0;

  const ChatBubble(
      {required this.isMine,
      required this.message,
      required this.senderUid,
      this.translations = const {},
      super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    // user avatar
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: ServiceLocator.instance.get<Database>().getUser(senderUid),
        builder: (context, state) {
          final photoUrl = state.data?.data()?.photoUrl;
          print('SUESI - photoUrl $photoUrl');
          return ClipRRect(
              borderRadius: BorderRadius.circular(_iconSize),
              child: photoUrl == null
                  ? const _DefaultPersonWidget()
                  : CachedNetworkImage(
                      imageUrl: photoUrl,
                      width: _iconSize,
                      height: _iconSize,
                      fit: BoxFit.fitWidth,
                      errorWidget: (context, url, error) =>
                          const _DefaultPersonWidget(),
                      placeholder: (context, url) =>
                          const _DefaultPersonWidget()));
        },
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // original language
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
          // english version (if there is)
          if (translations.isNotEmpty)
            ...translations.entries
                .where(
              (element) => element.key != 'original',
            )
                .map(
              (e) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        e.key,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isMine ? Colors.black87 : Colors.grey),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        e.value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: isMine ? Colors.black87 : Colors.grey),
                      ),
                    ),
                  ],
                );
              },
            )
        ],
      ),
    ));
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
