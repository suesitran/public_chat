import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/settings/chat_language/bloc/chat_language_bloc.dart';
import 'package:public_chat/features/settings/chat_language/ui/chat_language_setting_screen.dart';
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
          _buildChatLanguageItem(context),
          const Spacer(),
        ],
      ),
    );
  }

  _buildChatLanguageItem(BuildContext context) {
    return BlocBuilder<ChatLanguageBloc, ChatLanguageState>(
      builder: (context, state) {
        final subtitle = switch (state) {
          ChatLanguageChanged() => state.selectedLanguage.nativeName,
          ChatLanguageError() => context.locale.somethingError,
          _ => context.locale.loading,
        };

        return _buildSettingItem(
          context: context,
          title: context.locale.settingTranslationLanguage,
          subtitle: subtitle,
          onPressed: () => _goToChatLanguage(context),
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

  _goToChatLanguage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatLanguageSettingScreen(),
      ),
    );
  }
}
