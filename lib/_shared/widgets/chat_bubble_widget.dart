import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:public_chat/constants/app_texts.dart';
import 'package:public_chat/features/language/bloc/language_bloc.dart';

class ChatBubble extends StatefulWidget {
  final Future<bool> Function() onChatBubbleTap; // add click event to translate
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
  bool _isTranslating = false;
  String _translationStatus = "";

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
    widgets.add(
      BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) => GestureDetector(
          // Toggle tap to translate
          onTap: () async {
            // If there is already a translation, skip the button press status.
            if (widget.translations.containsKey(languageState.languageName)) {
              return;
            }

            // Get the message text: "translating" in the current language
            _translationStatus =
                languageState.textApp.containsKey(AppTexts.translatingStatus)
                    ? languageState.textApp[AppTexts.translatingStatus]
                    : AppTexts.translatingStatus;

            // turn on loading bar translating
            setState(() {
              _isTapped = true;
              _isTranslating = true;
            });

            //Get the message text: "translate fail" in the current language
            final success = await widget.onChatBubbleTap();

            if (!success) {
              _translationStatus = languageState.textApp
                      .containsKey(AppTexts.translatingFailStatus)
                  ? languageState.textApp[AppTexts.translatingFailStatus]
                  : AppTexts.translatingFailStatus;
            }

            // turn off loading bar translating
            setState(() {
              _isTranslating = false;
              if (success) {
                _isTapped = false;
              }
            });
          },
          child: Column(
            crossAxisAlignment: widget.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: _isTapped
                      ? Colors.blueGrey[700]
                      : widget.isMine
                          ? Colors.black26
                          : Colors.black87,
                  boxShadow: [
                    if (_isTapped)
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                  ],
                ),
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
                          color:
                              widget.isMine ? Colors.black87 : Colors.grey[300],
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
                    const SizedBox(height: 10),
                    // english version (if there is)
                    if (widget.translations.isNotEmpty)
                      ...widget.translations.entries
                          .where((element) => element.key != 'Original')
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
                                                : Colors.grey[300])),
                                TextSpan(
                                  text: e.value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          color: widget.isMine
                                              ? Colors.black87
                                              : Colors.grey[300]),
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
              // Translate Status bar
              if (_isTapped)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _isTranslating
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _translationStatus,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        )
                      : Text(
                          _translationStatus,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.redAccent,
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
    );

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
