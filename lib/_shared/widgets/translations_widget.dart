import 'package:flutter/material.dart';

import 'chat_bubble_widget.dart';

class TranslationsWidget extends StatelessWidget {
  const TranslationsWidget({
    super.key,
    required this.widget,
    required this.translations,
  });

  final ChatBubble widget;
  final Map<String, dynamic> translations;

  @override
  Widget build(BuildContext context) {
    return Column(
        //only translations
        children: translations.entries
            .where(
              (element) => element.key != 'original',
            )
            .map(
              (e) => Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: '${e.key} ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.isMine ? Colors.black87 : Colors.grey)),
                  TextSpan(
                    text: e.value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: widget.isMine ? Colors.black87 : Colors.grey),
                  )
                ]),
                textAlign: widget.isMine ? TextAlign.right : TextAlign.left,
              ),
            )
            .toList());
  }
}
