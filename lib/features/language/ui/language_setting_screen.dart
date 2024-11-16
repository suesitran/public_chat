import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/constants/app_texts.dart';
import 'package:public_chat/features/language/bloc/language_bloc.dart';
import 'package:public_chat/_shared/data/language_support_data.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.languageName),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    // Update hint to match user language
                    hintText: state.textApp.containsKey(AppTexts.searchLanguage)
                        ? state.textApp[AppTexts.searchLanguage]
                        : AppTexts.searchLanguage,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query.toLowerCase();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: supportedLanguageObjects.length,
                  itemBuilder: (context, index) {
                    final language = supportedLanguageObjects[index];
                    if (language.name.toLowerCase().contains(_searchQuery)) {
                      return ListTile(
                        leading: Image.network(
                          language.flagUrl,
                          width: 32,
                          height: 32,
                        ),
                        title: Text(language.name),
                        onTap: () {
                          context
                              .read<LanguageBloc>()
                              .add(ChangeLanguageEvent(language.name));
                          Navigator.pop(
                              context); // Close the language selection screen
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
