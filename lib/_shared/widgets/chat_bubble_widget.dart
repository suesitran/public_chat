import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String? photoUrl;
  final String? displayName;

  final double _iconSize = 24.0;

  const ChatBubble(
      {required this.isMine,
      required this.message,
      required this.photoUrl,
      required this.displayName,
      super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    // user avatar
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_iconSize),
        child: photoUrl == null
            ? const _DefaultPersonWidget()
            : CachedNetworkImage(
                imageUrl: photoUrl!,
                placeholder: (context, url) => const _DefaultPersonWidget(),
                errorWidget: (context, url, _) => const _DefaultPersonWidget(),
                width: _iconSize,
                height: _iconSize,
                fit: BoxFit.fitWidth,
              ),
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
          // display name
          Text(
            displayName ?? 'Unknown',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isMine ? Colors.black87 : Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
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
