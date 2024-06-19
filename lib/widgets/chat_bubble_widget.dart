import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:public_chat/data/chat_data.dart';
import 'package:public_chat/gen/assets.gen.dart';

class ChatBubble extends StatelessWidget {
  final Sender sender;
  final String? photoUrl;
  final String message;

  final double _iconSize = 24.0;

  const ChatBubble.user(this.message, {this.photoUrl, super.key})
      : sender = Sender.user;
  const ChatBubble.gemini(this.message, {super.key})
      : photoUrl = null,
        sender = Sender.gemini;

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
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white),
      ),
    ));
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
