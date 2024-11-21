import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import '../../features/translate_message.dart/bloc/translate_message_bloc.dart';
import '../../features/translate_message.dart/widgets/translation_widget.dart';
import '../data/chat_data.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String? photoUrl;
  final String? displayName;
  final List<TranslationModel> translations;

  const ChatBubble({
    required this.isMine,
    required this.message,
    required this.photoUrl,
    required this.displayName,
    this.translations = const [],
    super.key,
  });

  final double _iconSize = 24.0;
  @override
  Widget build(BuildContext context) {
    // user avatar
    final List<Widget> widgets = []; //cp at here
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
                onLoading: const _DefaultPersonWidget()),
      ),
    ));

    // message bubble
    widgets.add(Container(
        key: const Key('message_bubble'),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: isMine ? Colors.black26 : Colors.black87),
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TranslateMessageBloc, TranslateMessageState>(
            builder: (context, state) {
          return Column(
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
              // original language
              Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              if (state is EnableTranslateState)
                TranslationsWidget(
                  translations: getTranslations(state.selectedLanguages),
                  widget: this,
                )
            ],
          );
        })));

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

  List<TranslationModel> getTranslations(List<String> selectedLanguages) {
    List<TranslationModel> result = [];
    for (var selectedLanguage in selectedLanguages) {
      for (var translation in translations) {
        if (translation.languages.contains(selectedLanguage)) {
          result.add(translation);
        }
      }
    }
    return result;
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
