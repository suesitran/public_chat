import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/language_cubit.dart/language_cubit.dart';
import 'package:public_chat/features/language_manage/bloc/language_manage_bloc.dart';
import 'package:public_chat/features/language_manage/ui/widgets/language_item.dart';
import 'package:public_chat/utils/locale_support.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageManageScreen extends StatelessWidget {
  final bool onlyAppLanguage;

  const LanguageManageScreen({super.key, required this.onlyAppLanguage});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageManageBloc()
        ..add(LanguageManageInit(
            isFetchMessageLanguage: !onlyAppLanguage,
            appLanguage: context.read<LanguageCubit>().state.appLanguage,
            messageLanguage:
                context.read<LanguageCubit>().state.messageLanguage,
            supportedLocales: AppLocalizations.supportedLocales)),
      child: _LanguageManageBody(onlyAppLanguage),
    );
  }
}

class _LanguageManageBody extends StatelessWidget {
  final bool onlyAppLanguage;

  const _LanguageManageBody(this.onlyAppLanguage);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageManageBloc, LanguageManageState>(
      builder: (context, state) {
        final minChildSize = onlyAppLanguage ? 0.5 : 0.7;

        return DraggableScrollableSheet(
          initialChildSize: minChildSize,
          minChildSize: minChildSize,
          maxChildSize: 0.9,
          snap: true,
          builder: (context, scrollController) {
            Widget tabHeaderBuilder(String title, String? value) => Tab(
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      if (value != null)
                        Text(
                          "($value)",
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                );

            final appLanguages = _AppLanguagesScreen(
                state: state, scrollController: scrollController);
            final messageLanguages = _MessageLanguagesScreen(
                state: state, scrollController: scrollController);

            final tabBar = TabBar(
              tabAlignment:
                  onlyAppLanguage ? TabAlignment.start : TabAlignment.center,
              isScrollable: true,
              tabs: [
                if (!onlyAppLanguage)
                  tabHeaderBuilder(context.locale.messageLanguage,
                      state.messageLanguage?.showName ?? 'N/A'),
                tabHeaderBuilder(
                    context.locale.appLanguage,
                    onlyAppLanguage
                        ? null
                        : state.appLanguage?.showName ?? 'N/A'),
              ],
            );

            return DefaultTabController(
              length: tabBar.tabs.length,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(context.locale.selectLanguage),
                  bottom: tabBar,
                ),
                body: onlyAppLanguage
                    ? appLanguages
                    : TabBarView(
                        children: [
                          messageLanguages,
                          appLanguages,
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AppLanguagesScreen extends StatelessWidget {
  final LanguageManageState state;
  final ScrollController scrollController;

  const _AppLanguagesScreen(
      {required this.state, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: state.appLanguages.length,
      itemBuilder: (context, index) {
        final language = state.appLanguages[index];
        final isSelected = language.code == state.appLanguage?.code;

        return LanguageItem(
          isSelected: isSelected,
          index: index,
          language: language,
          onTap: (language) =>
              context.read<LanguageCubit>().setAppLanguage(language),
        );
      },
    );
  }
}

class _MessageLanguagesScreen extends StatefulWidget {
  final LanguageManageState state;
  final ScrollController scrollController;

  const _MessageLanguagesScreen(
      {required this.state, required this.scrollController});

  @override
  State<_MessageLanguagesScreen> createState() =>
      _MessageLanguagesScreenState();
}

class _MessageLanguagesScreenState extends State<_MessageLanguagesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Widget body;

    switch (widget.state.status) {
      case LanguageFetchStatus.initial:
        body = const Center(
          child: CircularProgressIndicator(),
        );
        break;
      case LanguageFetchStatus.failed:
        body = Center(child: Text(context.locale.languagesLoadFailed));
        break;
      case LanguageFetchStatus.success:
        final searchBar = TextFormField(
          controller: context.read<LanguageManageBloc>().searchTextController,
          onChanged: (value) => context
              .read<LanguageManageBloc>()
              .add(LanguageManageSearchTextChanged(searchText: value)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Visibility(
              visible: widget.state.searchText.isNotEmpty,
              child: IconButton(
                onPressed: () => context
                    .read<LanguageManageBloc>()
                    .add(LanguageManageClearSearchText()),
                icon: const Icon(Icons.close),
                color: Colors.red,
              ),
            ),
            hintText: '${context.locale.searchLanguage}...',
          ),
        );

        final languages = ListView.builder(
          controller: widget.scrollController,
          itemCount: widget.state.languagesFiltered.length,
          itemBuilder: (context, index) {
            final language = widget.state.languagesFiltered[index];
            final isSelected =
                language.code == widget.state.messageLanguage?.code;

            return LanguageItem(
              isSelected: isSelected,
              index: index,
              language: language,
              onTap: (language) =>
                  context.read<LanguageCubit>().setMessageLanguage(language),
            );
          },
        );

        body = Column(
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: searchBar),
            Expanded(child: languages),
          ],
        );

        break;
    }

    return body;
  }

  @override
  bool get wantKeepAlive => true;
}
