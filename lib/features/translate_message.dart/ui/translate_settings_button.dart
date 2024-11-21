import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/local_shared_data.dart';
import '../bloc/translate_message_bloc.dart';
import 'translate_popup.dart';
import 'my_dialog.dart';
import 'navigator.dart';

class TranslateSettingsButton extends StatelessWidget {
  const TranslateSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showSelectLang();
      },
      icon: const Icon(Icons.translate),
    );
  }
}

void showSelectLang() {
  List<String> getCurrentSelectedLanguages() {
    return LocalSharedData().getCurrentSelectedLanguages();
  }

  MyDialog.showMyDialog(
    titleText: 'Chọn ngôn ngữ dịch cho toàn bộ tin nhắn',
    contentWidget: BlocBuilder<TranslateMessageBloc, TranslateMessageState>(
      builder: (context, state) {
        return TranslatePopup(
          onSubmit: (value) {
            pop();
            final languages = value
                .split(' ')
                // .where((e) => e.isNotEmpty)
                .map((e) => e.trim().toLowerCase())
                .toList();
            languages.removeWhere((e) => e.isEmpty);
            context.read<TranslateMessageBloc>().add(EnableTranslateEvent(
                  languages: languages,
                ));
            LocalSharedData().setCurrentSelectedLanguages(languages);
          },
          fetchListHistoryLanguages: () async => getCurrentSelectedLanguages(),
        );
      },
    ),
    tapOutsideToClose: true,
    showCloseButton: false,
  );
}
