import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/settings/chat_language/bloc/chat_language_bloc.dart';
import 'package:public_chat/features/settings/chat_language/data/chat_language.dart';
import 'package:public_chat/features/settings/chat_language/ui/widgets/locale_icon.dart';
import 'package:public_chat/utils/locale_support.dart';

const kLanguageItemHeight = 56.0;
const kDividerItemHeight = 1.0;

class ChatLanguageSettingScreen extends StatefulWidget {
  const ChatLanguageSettingScreen({super.key});

  @override
  State<ChatLanguageSettingScreen> createState() =>
      _ChatLanguageSettingScreenState();
}

class _ChatLanguageSettingScreenState extends State<ChatLanguageSettingScreen> {
  ScrollController? _controller;

  // Handle auto scroll to item selected
  ScrollController _getScrollController({
    required BoxConstraints constraints,
    required EdgeInsets viewPadding,
    required ChatLanguageChanged state,
  }) {
    // Just auto scroll to select item in first time
    if (_controller != null) return _controller!;

    final selectedLanguage = state.supportedLanguages.firstWhere(
      (l) => l.code == state.selectedLanguage.code,
      orElse: () => ChatLanguage.defaultLanguage(),
    );

    final viewHeight = constraints.maxHeight - viewPadding.bottom;
    const itemHeight = (kLanguageItemHeight + kDividerItemHeight);

    final selectedIndex = state.supportedLanguages.indexOf(selectedLanguage);
    final selectedOffset = selectedIndex * itemHeight;

    final maxScrollExtent =
        (state.supportedLanguages.length * itemHeight) - viewHeight;

    final initialScrollOffset = selectedOffset > viewHeight
        ? min(max(0.0, selectedOffset - viewHeight / 2),
            maxScrollExtent) // Scroll select item to center of view
        : 0.0;

    _controller = ScrollController(initialScrollOffset: initialScrollOffset);
    return _controller!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatLanguageBloc, ChatLanguageState>(
      builder: (context, state) {
        final Widget body;
        if (state is ChatLanguageError) {
          body = Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.locale.somethingError),
                TextButton(
                  onPressed: () {
                    context
                        .read<ChatLanguageBloc>()
                        .add(ChatLoadLanguageEvent());
                  },
                  child: Text(context.locale.tryAgain),
                ),
              ],
            ),
          );
        } else if (state is ChatLanguageChanged) {
          body = LayoutBuilder(
            builder: (context, constraints) => ListView.separated(
              controller: _getScrollController(
                constraints: constraints,
                viewPadding: MediaQuery.viewPaddingOf(context),
                state: state,
              ),
              itemCount: state.supportedLanguages.length,
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom,
              ),
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(
                  left: 72,
                  right: 16,
                ),
                child: Divider(
                  height: kDividerItemHeight,
                  color: Colors.black12,
                ),
              ),
              itemBuilder: (context, index) {
                final language = state.supportedLanguages[index];

                return _buildLanguageItem(
                  context: context,
                  language: language,
                  selected: language.code == state.selectedLanguage.code,
                );
              },
            ),
          );
        } else {
          body = const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(context.locale.settingTranslationLanguage),
            elevation: 2,
          ),
          body: body,
        );
      },
    );
  }

  Widget _buildLanguageItem({
    required BuildContext context,
    required ChatLanguage language,
    required bool selected,
  }) {
    return SizedBox(
      height: kLanguageItemHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context
                .read<ChatLanguageBloc>()
                .add(ChatChangeLanguageEvent(language));
          },
          child: Row(
            children: [
              const SizedBox(width: 16),
              LocaleIcon(iconUrl: language.imageUrl),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  language.nativeName,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 16),
              Opacity(
                opacity: selected ? 1 : 0,
                child: const Icon(Icons.check),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
