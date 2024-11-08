import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/settings/genai_language/bloc/genai_language_bloc.dart';
import 'package:public_chat/features/settings/genai_language/data/genai_language.dart';
import 'package:public_chat/features/settings/genai_language/genai_language_setting_screen.dart';
import 'package:public_chat/features/settings/locale/bloc/locale_bloc.dart';
import 'package:public_chat/features/settings/locale/data/locale_info.dart';
import 'package:public_chat/features/settings/locale/ui/locale_setting_screen.dart';
import 'package:public_chat/utils/locale_support.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.settingTitle),
        elevation: 2,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppLanguageItem(context),
          const Padding(
            padding: EdgeInsets.only(left: 72, right: 16),
            child: Divider(height: 1, color: Colors.black12),
          ),
          _buildGenaiLanguageItem(context),
        ],
      ),
    );
  }

  _buildAppLanguageItem(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) => _buildSettingItem(
        context: context,
        title: context.locale.settingAppLanguage,
        subtitle: LocaleInfo.from(languageCode: state.locale.languageCode).name,
        onPressed: () => _goToAppLanguage(context),
      ),
    );
  }

  _buildGenaiLanguageItem(BuildContext context) {
    return BlocBuilder<GenaiLanguageBloc, GenaiLanguageState>(
      builder: (context, state) {
        final language = GenAiLanguage.values.firstWhere(
          (l) => l.languageName == (state.language ?? ""),
        );

        return _buildSettingItem(
          context: context,
          title: context.locale.settingGenaiLanguage,
          subtitle: language == GenAiLanguage.auto
              ? context.locale.genaiAutoLanguage
              : language.displayName,
          onPressed: () => _goToAssistantLanguage(context),
        );
      },
    );
  }

  _buildSettingItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(left: 72, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _goToAppLanguage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocaleSettingScreen(),
      ),
    );
  }

  _goToAssistantLanguage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GenaiLanguageSettingScreen(),
      ),
    );
  }
}
