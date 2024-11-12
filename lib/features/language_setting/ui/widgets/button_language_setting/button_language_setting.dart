import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/language_setting/bloc/user_language_cubit.dart';
import 'package:public_chat/features/language_setting/constants.dart';
import 'package:public_chat/features/language_support/data/language.dart';

import '../../language_setting_screen.dart';

class ButtonLanguageSetting extends StatelessWidget {
  const ButtonLanguageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingLanguageScreen(),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: BlocBuilder<UserLanguageCubit, String>(
          builder: (context, state) {
            LanguageSupport languageUser = context.languageUserObject(state);
            return Text(
              languageUser.flag ?? '',
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ),
    );
  }
}
