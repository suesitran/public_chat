import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/settings/genai_language/bloc/genai_language_bloc.dart';
import 'package:public_chat/features/settings/genai_language/data/genai_language.dart';
import 'package:public_chat/features/settings/locale/ui/widgets/locale_icon.dart';
import 'package:public_chat/utils/locale_support.dart';

const kLanguageItemHeight = 56.0;
const kDividerItemHeight = 1.0;

class GenaiLanguageSettingScreen extends StatefulWidget {
  const GenaiLanguageSettingScreen({super.key});

  @override
  State<GenaiLanguageSettingScreen> createState() =>
      _GenaiLanguageSettingScreenState();
}

class _GenaiLanguageSettingScreenState
    extends State<GenaiLanguageSettingScreen> {
  ScrollController? _controller;

  // Handle auto scroll to item selected
  ScrollController _getScrollController({
    required BoxConstraints constraints,
    required EdgeInsets viewPadding,
    required GenaiLanguageState state,
  }) {
    // Just auto scroll to select item in first time
    if (_controller != null) return _controller!;

    final selectedLanguage = GenAiLanguage.values.firstWhere(
      (l) => l.languageName == state.language,
      orElse: () => GenAiLanguage.auto,
    );

    final viewHeight = constraints.maxHeight - viewPadding.bottom;
    const itemHeight = (kLanguageItemHeight + kDividerItemHeight);

    final selectedIndex = GenAiLanguage.values.indexOf(selectedLanguage);
    final selectedOffset = selectedIndex * itemHeight;

    final maxScrollExtent =
        (GenAiLanguage.values.length * itemHeight) - viewHeight;

    final initialScrollOffset = selectedOffset > viewHeight
        ? min(max(0.0, selectedOffset - viewHeight / 2),
            maxScrollExtent) // Scroll select item to center of view
        : 0.0;

    _controller = ScrollController(initialScrollOffset: initialScrollOffset);
    return _controller!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenaiLanguageBloc, GenaiLanguageState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(context.locale.genaiLanguageSettingTitle),
          elevation: 2,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => ListView.separated(
            controller: _getScrollController(
              constraints: constraints,
              viewPadding: MediaQuery.viewPaddingOf(context),
              state: state,
            ),
            itemCount: GenAiLanguage.values.length,
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
              final language = GenAiLanguage.values[index];

              return _buildLanguageItem(
                context: context,
                language: language,
                selected: (language == GenAiLanguage.auto &&
                        state.language == null) ||
                    language.languageName == state.language,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageItem({
    required BuildContext context,
    required GenAiLanguage language,
    required bool selected,
  }) {
    bool isAutoItem = language == GenAiLanguage.auto;
    return SizedBox(
      height: kLanguageItemHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final languageName = isAutoItem ? null : language.languageName;

            context
                .read<GenaiLanguageBloc>()
                .add(GenaiChangeLanguageEvent(languageName));
          },
          child: Row(
            children: [
              const SizedBox(width: 16),
              isAutoItem
                  ? Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: const Icon(
                        size: 18,
                        Icons.auto_awesome,
                        color: Colors.white,
                      ),
                    )
                  : LocaleIcon(iconUrl: language.imageUrl),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  isAutoItem
                      ? context.locale.genaiAutoLanguage
                      : language.displayName,
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
