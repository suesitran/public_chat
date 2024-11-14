import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import '../../features/translate_settings/trans_bloc.dart';
import '../../features/translate_settings/widgets/translate_settings_button.dart';
import '../button/button_with_popup.dart';
import '../dialog/loading_dialog.dart';
import 'translations_widget.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final String? photoUrl;
  final String? displayName;
  final Map<String, dynamic> translations;
  final String id;

  const ChatBubble(
      {required this.isMine,
      required this.message,
      required this.photoUrl,
      required this.displayName,
      this.translations = const {},
      super.key,
      required this.id});

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
    final messageBubble = Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: isMine ? Colors.black26 : Colors.black87),
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TransBloc, TransState>(builder: (context, state) {
          if (!isMine && state is ChangeLangState) {
            print('state: ${state.selectedLanguages}');
            context.read<TransBloc>().getTranslations(
                message: message,
                selectedLanguages: state.selectedLanguages,
                messageID: id);
          }
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
              if (state is TransLoading)
                const LoadingState()
              else if (state is TransResult)
                TranslationsWidget(
                  translations: state.resultTranslations,
                  widget: this,
                )
            ],
          );
        }));
    widgets.add(ButtonWithPopup<String>(
        items: [
          DropdownMenuItem(
            child: const Text('Copy'),
            onTap: () {
              Clipboard.setData(ClipboardData(text: message));
            },
          ),
          DropdownMenuItem(
            child: const Text('Dịch'),
            onTap: () {
              showSelectLang();
            },
          ),
          DropdownMenuItem(
            child: const Text('Tìm kiếm'),
            onTap: () {
//TODO
            },
          ),
          DropdownMenuItem(
            child: const Text('Hỏi Gemini'),
            onTap: () {
//TODO
            },
          ),
          if (isMine)
            DropdownMenuItem(
              child: const Text('Xóa'),
              onTap: () {
//TODO
              },
            ),
        ],
        onTap: () async {
          //TODO: transalte by ONE TAP
        },
        child: messageBubble));

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
