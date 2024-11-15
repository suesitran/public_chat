import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/localization_manager/localization_manager_cubit.dart';
import 'package:public_chat/_shared/data/app_language.dart';
import 'package:public_chat/_shared/widgets/language_button.dart';
import 'package:public_chat/utils/locale_support.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.setting),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.locale.appLanguage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.locale.selectLanguage),
                const SizedBox(
                  width: 8,
                ),
                BlocBuilder<LocalizationManagerCubit, LocalizationManagerState>(
                    builder: (context, state) {
                  return DropdownButton<Locale>(
                    value: state.locale,
                    items: List.generate(
                      AppLanguage.values.length,
                      (index) {
                        return DropdownMenuItem(
                            value: Locale(AppLanguage.values[index].name),
                            child: Row(
                              children: [
                                LanguageFlag(
                                  language: Language.fromCode(AppLanguage
                                      .values[index]
                                      .name), // OR Language.fromCode('ar')
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  AppLanguage.values[index].languageName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ));
                      },
                    ),
                    onChanged: (locale) {
                      BlocProvider.of<LocalizationManagerCubit>(context)
                          .changeUserChatLanguage(locale);
                    },
                  );
                }),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              context.locale.chatLanguage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.locale.selectLanguage),
                const SizedBox(
                  width: 8,
                ),
                const LanguageButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
