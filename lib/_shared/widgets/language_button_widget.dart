import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/language_cubit.dart/language_cubit.dart';
import 'package:public_chat/features/language_manage/ui/language_manage_screen.dart';

class LanguageButtonWidget extends StatelessWidget {
  final bool onlyAppLanguage;

  const LanguageButtonWidget({super.key, this.onlyAppLanguage = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final content = onlyAppLanguage
            ? Row(
                children: [
                  if (state.appLanguage != null)
                    Image.network(
                      state.appLanguage!.flagUrl,
                      height: 18,
                      width: 28,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 18,
                        width: 28,
                        color: Colors.blue.shade200,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.info,
                          size: 15,
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Text(state.appLanguage?.code.toUpperCase() ?? 'N/A'),
                ],
              )
            : const Icon(Icons.settings);

        return Container(
          height: 32,
          width: onlyAppLanguage ? null : 40,
          margin: const EdgeInsets.only(right: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: onlyAppLanguage
                    ? const EdgeInsets.symmetric(horizontal: 8)
                    : EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              builder: (context) => LanguageManageScreen(
                onlyAppLanguage: onlyAppLanguage,
              ),
            ),
            child: content,
          ),
        );
      },
    );
  }
}
