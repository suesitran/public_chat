import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/local_shared_data.dart';
import '../bloc/translate_message_bloc.dart';
import 'navigator.dart';
import 'translate_popup.dart';
import 'my_dialog.dart';

class TranslateSettingsButton extends StatelessWidget {
  const TranslateSettingsButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showSelectLang(context);
      },
      icon: const Icon(Icons.translate),
    );
  }

  void showSelectLang(BuildContext context) {
    MyDialog.showMyDialog(
      context,
      titleText: 'Select languages to translate messages',
      contentWidget: BlocBuilder<TranslateMessageBloc, TranslateMessageState>(
        builder: (context, state) {
          return TranslatePopup(
            onSubmit: (value) {
              pop();
              if (value.isEmpty) {
                return;
              }
              final languages = value
                  .split(',')
                  .map((e) => e.trim().toLowerCase())
                  .where((e) => e.isNotEmpty)
                  .toSet()
                  .toList();
              LocalSharedData().setCurrentSelectedLanguages(languages);
              context.read<TranslateMessageBloc>().add(EnableTranslateEvent(
                    languages: languages,
                  ));
            },
            fetchListHistoryLanguages: () async =>
                LocalSharedData().getCurrentSelectedLanguages(),
          );
        },
      ),
      tapOutsideToClose: true,
      showActions: false,
      actions: [
        TextButton(
            onPressed: () {}, //TODO
            child: const Text('Add languages to previous languages')),
        TextButton(
            onPressed: () {}, //TODO
            child: const Text('Add & replace previous languages')),
      ],
    );
  }
}
