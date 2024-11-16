import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/chat/bloc/chat_cubit.dart';
import 'package:public_chat/utils/locale_support.dart';

class ViewTranslation extends StatefulWidget {
  const ViewTranslation({
    super.key,
    required this.message,
    required this.messageId,
    required this.translations,
    required this.currentLocale,
  });
  final String currentLocale;
  final String message;
  final String messageId;
  final Map<String, dynamic> translations;

  @override
  State<ViewTranslation> createState() => _ViewTranslationState();
}

class _ViewTranslationState extends State<ViewTranslation> {
  final _isLoading = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    if (widget.translations.isNotEmpty) {
      final matchedLocale = widget.translations.entries
          .firstWhereOrNull((element) => element.key == widget.currentLocale);
      if (matchedLocale != null) {
        return Text.rich(
          TextSpan(children: [
            TextSpan(
                text: '${matchedLocale.key} ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.grey)),
            TextSpan(
              text: matchedLocale.value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey),
            )
          ]),
          textAlign: TextAlign.left,
        );
      }
    }
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (context, value, child) {
        if (value) {
          return const CircularProgressIndicator();
        }
        return TextButton(
            onPressed: () {
              _isLoading.value = true;
              context
                  .read<ChatCubit>()
                  .translate(
                    widget.message,
                    toLocale: Locale(context.locale.localeName),
                    messageId: widget.messageId,
                  )
                  .whenComplete(() {
                _isLoading.value = false;
              });
            },
            child: const Text('See translation'));
      },
    );
  }
}
