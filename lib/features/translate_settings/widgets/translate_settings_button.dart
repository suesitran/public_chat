import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/dialog/message_dialog.dart';
import '../../../config/routes/navigator.dart';
import '../../../utils/local_shared_data.dart';
import '../trans_bloc.dart';
import '../translate_popup.dart';

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
  List<String> _getHistoryLanguages() {
    return LocalSharedData().getListHistoryLanguages();
  }

  MessageDialog.showMessageDialog(
    titleText: 'Chọn ngôn ngữ dịch cho toàn bộ tin nhắn',
    contentWidget: BlocBuilder<TransBloc, TransState>(
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
            print('languages: $languages');
            // if (languages.length > maxLanguages) {
            //   languages.sublist(0, maxLanguages);
            // }
            context.read<TransBloc>().add(SelectLanguageEvent(
                  languages: languages,
                ));
            LocalSharedData().setChatLanguagesAndHistoryLanguages(languages);
          },
          fetchListHistoryLanguages: () async => _getHistoryLanguages(),
        );
      },
    ),
    tapOutsideToClose: true,
    showCloseButton: false,
  );
}
