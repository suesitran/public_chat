import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class ChatBubble extends StatefulWidget {
  final VoidCallback onChatBubbleTap;
  final bool isMine;
  final String message;
  final String? photoUrl;
  final String? displayName;
  final Map<String, dynamic> translations;

  const ChatBubble(
      {required this.isMine,
      required this.message,
      required this.photoUrl,
      required this.displayName,
      this.translations = const {},
      required this.onChatBubbleTap,
      super.key});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final double _iconSize = 24.0;
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
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
    widgets.add(GestureDetector(
        onTap: () {
          setState(() {
            _isTapped = true; // Toggle tap state
          });
          widget.onChatBubbleTap();
        },
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: _isTapped
                      ? (widget.isMine
                          ? Colors.black54
                          : Colors.blueGrey) // Change color on tap
                      : widget.isMine
                          ? Colors.black26
                          : Colors.black87),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: widget.isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // display name
                  Text(
                    widget.displayName ?? 'Unknown',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.isMine ? Colors.black87 : Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // original language
                  Text(
                    widget.message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  // english version (if there is)
                  if (widget.translations.isNotEmpty)
                    ...widget.translations.entries
                        .where(
                          (element) => element.key != 'Original',
                        )
                        .map(
                          (e) => Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: '${e.key}: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: widget.isMine
                                              ? Colors.black87
                                              : Colors.grey)),
                              TextSpan(
                                text: e.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: widget.isMine
                                            ? Colors.black87
                                            : Colors.grey),
                              )
                            ]),
                            textAlign: widget.isMine
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        )
                ],
              ),
            ),
          ],
        )));
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
