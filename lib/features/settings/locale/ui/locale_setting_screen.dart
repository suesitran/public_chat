import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/settings/locale/bloc/locale_bloc.dart';
import 'package:public_chat/features/settings/locale/data/locale_info.dart';
import 'package:public_chat/features/settings/locale/ui/widgets/locale_icon.dart';
import 'package:public_chat/utils/locale_support.dart';

class LocaleSettingScreen extends StatelessWidget {
  const LocaleSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(context.locale.languageSettingTitle),
        ),
        body: ListView.separated(
          itemCount: AppLocalizationsExt.supportedLocaleInfos.length,
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(left: 72, right: 16),
            child: Divider(
              height: 1,
              color: Colors.black12,
            ),
          ),
          itemBuilder: (context, index) {
            final localeInfo = AppLocalizationsExt.supportedLocaleInfos[index];

            return _buildLanguageItem(
              context: context,
              localeInfo: localeInfo,
              selected: localeInfo.code == state.locale.languageCode,
            );
          },
        ),
      ),
    );
  }

  Widget _buildLanguageItem({
    required BuildContext context,
    required LocaleInfo localeInfo,
    required bool selected,
  }) {
    return SizedBox(
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context
                .read<LocaleBloc>()
                .add(ChangeLocaleEvent(Locale(localeInfo.code)));
          },
          child: Row(
            children: [
              const SizedBox(width: 16),
              LocaleIcon(iconUrl: localeInfo.imageUrl),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  localeInfo.name,
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
