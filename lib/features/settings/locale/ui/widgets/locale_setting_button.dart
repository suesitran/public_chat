import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/settings/locale/bloc/locale_bloc.dart';
import 'package:public_chat/features/settings/locale/data/locale_info.dart';
import 'package:public_chat/features/settings/locale/ui/locale_setting_screen.dart';
import 'package:public_chat/features/settings/locale/ui/widgets/locale_icon.dart';

class LocaleSettingButton extends StatelessWidget {
  const LocaleSettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) => IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LocaleSettingScreen(),
            ),
          );
        },
        icon: LocaleIcon(
          iconUrl:
              LocaleInfo.from(languageCode: state.locale.languageCode).imageUrl,
        ),
      ),
    );
  }
}
