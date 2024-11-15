import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';

import 'language_bottom_sheet.dart';

class LanguageButton extends StatelessWidget {
  final Function()? onClosedBottomSheet;
  final double flagHeight;

  const LanguageButton({
    super.key,
    this.onClosedBottomSheet,
    this.flagHeight = 20,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserManagerCubit, UserManagerState>(
        builder: (context, state) {
      return InkWell(
        onTap: () => showLanguageBottomSheet(context),
        child: Row(
          children: [
            Text(
              state.chatLanguage?.langCode ?? "",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const SizedBox(
              width: 4,
            ),
            LanguageFlag(
              language: Language.fromCode(state.chatLanguage?.langCode ??
                  ""), // OR Language.fromCode('ar')
              height: flagHeight,
            ),
          ],
        ),
      );
    });
  }

  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      isDismissible: true,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const LanguageBottomSheet();
      },
    ).then((value) {
      if (onClosedBottomSheet != null) {
        onClosedBottomSheet!();
      }
    });
  }
}
