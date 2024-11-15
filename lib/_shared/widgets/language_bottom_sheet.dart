import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/models/entities/language_entity.dart';
import 'package:public_chat/repository/language_repository.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late final UserManagerCubit userManagerCubit;
  List<LanguageEntity> filteredLanguages = [];
  final ScrollController scrollController = ScrollController();
  int? selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    userManagerCubit = BlocProvider.of<UserManagerCubit>(context);
    filteredLanguages.addAll(LanguageRepository.instance.languages);
    selectedIndex = filteredLanguages.indexWhere((language) =>
        language.langCode == userManagerCubit.state.chatLanguage?.langCode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onChanged: (value) {
              setState(() {
                filteredLanguages =
                    LanguageRepository.instance.languages.where((language) {
                  bool isLangEnglishNameContains =
                      language.langEnglishName?.toLowerCase().contains(
                                value.toLowerCase(),
                              ) ??
                          false;
                  bool isLangNativeName =
                      language.langNativeName?.toLowerCase().contains(
                                value.toLowerCase(),
                              ) ??
                          false;
                  return isLangEnglishNameContains || isLangNativeName;
                }).toList();
              });
            },
            decoration: const InputDecoration(
              labelText: 'Enter language code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: filteredLanguages.length,
              itemBuilder: (context, index) {
                final LanguageEntity language = filteredLanguages[index];
                return InkWell(
                  onTap: () async {
                    setState(() {
                      selectedIndex = index;
                    });
                    context.loaderOverlay.show();
                    await userManagerCubit.updateUserChatLanguage(language);
                    if (context.mounted) {
                      context.loaderOverlay.hide();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        LanguageFlag(
                          language: Language.fromCode(language.langCode ??
                              ""), // OR Language.fromCode('ar')
                          height: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${language.langEnglishName ?? ""} / ${language.langNativeName ?? ""}",
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (index == selectedIndex)
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.check,
                                size: 24,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 10,
                  color: Colors.black.withOpacity(0.1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
