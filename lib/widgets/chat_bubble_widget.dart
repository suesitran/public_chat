import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:public_chat/data/chat_data.dart';
import 'package:public_chat/gen/assets.gen.dart';

class ChatBubble extends StatelessWidget {
  final Sender sender;
  final String? photoUrl;
  final ChatData chatData;

  final double _iconSize = 24.0;

  const ChatBubble.user(this.chatData, {this.photoUrl, super.key})
      : sender = Sender.user;
  const ChatBubble.gemini(this.chatData, {super.key})
      : photoUrl = null,
        sender = Sender.gemini;

  const ChatBubble(this.sender, this.photoUrl, this.chatData, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    // user avatar
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(_iconSize),
          child: sender == Sender.gemini
              ? SvgPicture.asset(
                  Assets.googleGeminiIcon,
                  width: _iconSize,
                  height: _iconSize,
                )
              : photoUrl == null
                  ? const _DefaultPersonWidget()
                  : CachedNetworkImage(
                      imageUrl: photoUrl!,
                      width: _iconSize,
                      height: _iconSize,
                      fit: BoxFit.fitWidth,
                      errorWidget: (context, url, error) =>
                          const _DefaultPersonWidget(),
                      placeholder: (context, url) =>
                          const _DefaultPersonWidget())),
    ));

    // message bubble
    widgets.add(Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: isMine ? Colors.black26 : Colors.black87),
        padding: const EdgeInsets.all(8.0),
        child:
            _DataContainer(chatData, isMine ? Colors.black87 : Colors.white)));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMine ? widgets.reversed.toList() : widgets,
      ),
    );
  }

  bool get isMine => sender == Sender.user;
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

class _DataContainer extends StatelessWidget {
  final ChatData data;
  final Color color;

  const _DataContainer(this.data, this.color, {super.key});

  // TODO implement UI for File and Memory data
  @override
  Widget build(BuildContext context) => switch (data) {
        TextData text => Text(
            text.message,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          ),
        FileData file => Text(
            'File: ${file.file.path}',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          ),
        MemoryData _ => Text(
            'Data from Memory',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          ),
        _ => Text(
            'Unknown data',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          )
      };
}
