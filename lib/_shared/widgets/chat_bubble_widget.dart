import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:public_chat/features/translation_message/bloc/translation_message_bloc.dart';
import 'package:public_chat/utils/locale_support.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String messageId;
  final String? photoUrl;
  final String? displayName;
  final Map<String, dynamic> translations;
  final String? selectedLanguageCode;

  final double _iconSize = 24.0;

  const ChatBubble({
    required this.isMine,
    required this.message,
    required this.messageId,
    required this.photoUrl,
    required this.displayName,
    required this.selectedLanguageCode,
    this.translations = const {},
    super.key,
  });

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
                onLoading: const _DefaultPersonWidget()),
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
          // original language
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),

          // Translation section
          if (selectedLanguageCode != null) ...[
            const SizedBox(height: 4),
            BlocBuilder<TranslationMessageBloc, TranslationMessageState>(
              buildWhen: (previous, current) =>
                  previous.visibleTranslations != current.visibleTranslations ||
                  previous.messagesInTranslation !=
                      current.messagesInTranslation,
              builder: (context, state) {
                final bool isTranslationVisible =
                    state.visibleTranslations.contains(messageId);
                final bool hasTranslation =
                    translations.containsKey(selectedLanguageCode);

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasTranslation && isTranslationVisible)
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            // Hide translation when tapped
                            context
                                .read<TranslationMessageBloc>()
                                .add(ToggleTranslationVisibility(messageId));
                          },
                          child: Text(
                            translations[selectedLanguageCode],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color:
                                        isMine ? Colors.black87 : Colors.grey),
                          ),
                        ),
                      ),
                    if (hasTranslation && isTranslationVisible)
                      const SizedBox(width: 8),
                    if (
                        // Show loading indicator when translation is not visible
                        state.messagesInTranslation.contains(messageId))
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white70),
                        ),
                      )
                    else if (!isTranslationVisible)
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: hasTranslation
                            ? () {
                                // Show existing translation
                                context.read<TranslationMessageBloc>().add(
                                    ToggleTranslationVisibility(messageId));
                              }
                            : () {
                                // Request translation
                                context
                                    .read<TranslationMessageBloc>()
                                    .add(TranslateMessageRequested(
                                      messageId: messageId,
                                      message: message,
                                    ));
                              },
                        child: Text(
                          context.locale.translate,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
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
