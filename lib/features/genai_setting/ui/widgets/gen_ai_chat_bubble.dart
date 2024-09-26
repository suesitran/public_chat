import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class GenAIChatBubble extends StatelessWidget {
  final bool isMine;
  final String? photoUrl;
  final String message;

  final double _iconSize = 24.0;

  const GenAIChatBubble(
      {required this.isMine,
      required this.photoUrl,
      required this.message,
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
              : ImageNetwork(
                  image: photoUrl!,
                  width: _iconSize,
                  height: _iconSize,
                  fitAndroidIos: BoxFit.fitWidth,
                  fitWeb: BoxFitWeb.contain,
                  onError: const _DefaultPersonWidget(),
                  onLoading: const _DefaultPersonWidget())),
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
