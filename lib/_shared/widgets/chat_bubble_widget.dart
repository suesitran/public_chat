import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final bool isMine;
  final String message;
  final String? photoUrl;
  final String? displayName;
  final Map<String, dynamic> translations;

  const ChatBubble({
    required this.isMine,
    required this.message,
    required this.photoUrl,
    required this.displayName,
    this.translations = const {},
    super.key,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with AutomaticKeepAliveClientMixin {
  final double _iconSize = 24.0;
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Widget> widgets = [
      _buildAvatar(),
      _buildMessageBubble(context),
    ];

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

  Widget _buildAvatar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_iconSize),
        child: widget.photoUrl == null
            ? const _DefaultPersonWidget()
            : CachedNetworkImage(
                imageUrl: widget.photoUrl!,
                width: _iconSize,
                height: _iconSize,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => const _DefaultPersonWidget(),
                errorWidget: (context, url, error) =>
                    const _DefaultPersonWidget(),
              ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: widget.isMine ? Colors.black26 : Colors.black87,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            widget.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _buildDisplayName(context),
          _buildOriginalMessage(context),
          if (widget.translations.isNotEmpty) ..._buildTranslations(context),
        ],
      ),
    );
  }

  Widget _buildDisplayName(BuildContext context) {
    return Text(
      widget.displayName ?? 'Unknown',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: widget.isMine ? Colors.black87 : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildOriginalMessage(BuildContext context) {
    return Text(
      widget.message,
      style:
          Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
    );
  }

  List<Widget> _buildTranslations(BuildContext context) {
    return widget.translations.entries
        .where((element) => element.key != 'original')
        .map(
          (e) => Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${e.key} ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.isMine ? Colors.black87 : Colors.grey,
                      ),
                ),
                TextSpan(
                  text: e.value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: widget.isMine ? Colors.black87 : Colors.grey,
                      ),
                ),
              ],
            ),
            textAlign: widget.isMine ? TextAlign.right : TextAlign.left,
          ),
        )
        .toList();
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
