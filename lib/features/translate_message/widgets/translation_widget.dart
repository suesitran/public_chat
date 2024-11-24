import 'package:flutter/material.dart';

import '../../../_shared/data/chat_data.dart';
import '../../../_shared/widgets/chat_bubble_widget.dart';

class TranslationsWidget extends StatelessWidget {
  const TranslationsWidget({
    super.key,
    required this.widget,
    required this.translations,
  });

  final ChatBubble widget;
  final List<TranslationModel> translations;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: translations
            .map(
              (e) => Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: '${e.code} ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.isMine ? Colors.black87 : Colors.grey)),
                  TextSpan(
                    text: e.translation,
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
