import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/language_setting/bloc/user_language_cubit.dart';
import 'package:public_chat/features/language_support/bloc/language_support_cubit.dart';
import 'package:public_chat/utils/locale_support.dart';

import '../../language_support/data/language.dart';
import '../bloc/language_setting_cubit.dart';

class SettingLanguageScreen extends StatelessWidget {
  const SettingLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<LanguageSettingCubit>(
        create: (context) =>
            LanguageSettingCubit(context.read<UserLanguageCubit>().state),
        child: const _SettingLangeScreenBody(),
      );
}

class _SettingLangeScreenBody extends StatelessWidget {
  const _SettingLangeScreenBody();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.locale.settingLanguage),
        ),
        body: BlocBuilder<LanguageSupportCubit, List<LanguageSupport>>(
          builder: (context, listLanguage) {
            if (listLanguage.isEmpty) {
              return Container();
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                var dataLanguage = listLanguage[index];
                return ChildLanguage(dataLanguage);
              },
              itemCount: listLanguage.length,
            );
          },
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () {
            context.read<LanguageSettingCubit>().saveLanguage();
            Navigator.pop(context);
          },
          style: ButtonStyle(
              fixedSize: WidgetStateProperty.all(const Size.fromHeight(70)),
              shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero)),
              backgroundColor: WidgetStateProperty.all(Colors.green)),
          child: const Text('OK',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
        ),
      );
}

class ChildLanguage extends StatelessWidget {
  final LanguageSupport dataLanguage;
  const ChildLanguage(this.dataLanguage, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _chooseLanguage(dataLanguage, context),
      child: BlocBuilder<LanguageSettingCubit, String>(
        builder: (context, state) {
          return RadioListTile<LanguageSupport>(
            value: dataLanguage,
            onChanged: (choose) => _chooseLanguage(dataLanguage, context),
            title: Row(
              children: [
                Text(dataLanguage.nativeName ?? ''),
                const SizedBox(
                  width: 10,
                ),
                Text(dataLanguage.flag ?? '',
                    style: const TextStyle(fontSize: 24))
              ],
            ),
            groupValue: LanguageSupport(code: state),
          );
        },
      ),
    );
  }

  _chooseLanguage(LanguageSupport dataLanguage, BuildContext context) {
    context.read<LanguageSettingCubit>().chooseLanguage(dataLanguage);
  }
}
