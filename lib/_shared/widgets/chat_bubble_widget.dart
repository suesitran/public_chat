import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import '../../features/translate_settings/trans_bloc.dart';
import '../../features/translate_settings/widgets/translate_settings_button.dart';
import '../../utils/send_to_gemini.dart';
import '../button/button_with_popup.dart';
import '../dialog/loading_dialog.dart';
import 'translations_widget.dart';

// ignore: must_be_immutable
class ChatBubble extends StatefulWidget {
  final bool isMine;
  final String message;
  final String? photoUrl;
  final String? displayName;
  final Map<String, dynamic> translations;
  final String id;

  const ChatBubble(
      {required this.isMine,
      required this.message,
      required this.photoUrl,
      required this.displayName,
      this.translations = const {},
      super.key,
      required this.id});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final double _iconSize = 24.0;
  @override
  Widget build(BuildContext context) {
    print('build ChatBubble: ${widget.displayName}');
    // user avatar
    final List<Widget> widgets = []; //cp at here
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_iconSize),
        child: widget.photoUrl == null
            ? const _DefaultPersonWidget()
            : ImageNetwork(
                image: widget.photoUrl!,
                width: _iconSize,
                height: _iconSize,
                fitAndroidIos: BoxFit.fitWidth,
                fitWeb: BoxFitWeb.contain,
                onError: const _DefaultPersonWidget(),
                onLoading: const _DefaultPersonWidget()),
      ),
    ));

    // message bubble
    final messageBubble = Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: widget.isMine ? Colors.black26 : Colors.black87),
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TransBloc, TransState>(builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: widget.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // display name
              Text(
                widget.displayName ?? 'Unknown',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.isMine ? Colors.black87 : Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              // original language
              Text(
                widget.message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              // english version (if there is)
              if (state is ChangeLangState && !widget.isMine)
                FutureBuilder<Map<String, dynamic>>(
                  future: getTranslations(
                      context, widget.message, state.selectedLanguages),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Đang dịch...');
                    }
                    if (snapshot.hasData) {
                      print('snapshot.data: ${snapshot.data}');
                      return TranslationsWidget(
                        widget: widget,
                        translations: snapshot.data!,
                      );
                    }
                    return const LoadingState();
                  },
                )
            ],
          );
        }));
    widgets.add(ButtonWithPopup<String>(
        items: [
          DropdownMenuItem(
            child: const Text('Copy'),
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.message));
            },
          ),
          DropdownMenuItem(
            child: const Text('Dịch'),
            onTap: () {
              showSelectLang();
            },
          ),
          DropdownMenuItem(
            child: const Text('Tìm kiếm'),
            onTap: () {
//TODO
            },
          ),
          DropdownMenuItem(
            child: const Text('Hỏi Gemini'),
            onTap: () {
//TODO
            },
          ),
          if (widget.isMine)
            DropdownMenuItem(
              child: const Text('Xóa'),
              onTap: () {
//TODO
              },
            ),
        ],
        onTap: () async {
          //TODO: transalte by ONE TAP
        },
        child: messageBubble));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: widget.isMine ? widgets.reversed.toList() : widgets,
      ),
    );
  }

  Map<String, dynamic> _resultTranslations = {};
  List<String> _previousLanguages = [];
  Future<Map<String, dynamic>> getTranslations(BuildContext context,
      String message, List<String> selectedLanguages) async {
    print('getTranslations');
    //nếu có lang dịch rồi, lang chưa: vẫn lấy "translations" từ firestore vì lang dịch rồi đó sẽ có trên firebase
    if (_previousLanguages.equal(selectedLanguages)) {
      print('selectedLanguages is equal: $selectedLanguages');
      return _resultTranslations;
    } else {
      print(
          'selectedLanguages is not equal: $selectedLanguages, _previousLanguages:$_previousLanguages');
      _previousLanguages = selectedLanguages;
      _resultTranslations = {}; //cp reset
    }
    //get translations from firestore
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('translations')
        .doc(widget.id)
        .get();
    //neu id chua exist, them vao firestore
    if (!data.exists) {
      await FirebaseFirestore.instance
          .collection('translations')
          .doc(widget.id)
          .set({'id ko ton tai': 'id ko ton tai => them moi'});
      data = await FirebaseFirestore.instance
          .collection('translations')
          .doc(widget.id)
          .get();
    }
    Map<String, dynamic> translations = data.data() ?? {};
    print('translations: $translations');
    List<String> listLangSendToGemini = [];
    for (String lang in selectedLanguages) {
      bool hasTranslated = false;
      for (var e in translations.entries) {
        if (lang.toLowerCase() == e.key.toLowerCase()) {
          _resultTranslations[lang] = "translated: " +
              e.value; //đã có trên firestore rồi, ko cần dịch nữa
          print(
              'da co tren firestore: translations[${e.key}]: ${translations[e.key]}');
          hasTranslated = true;
          break;
        }
      }
      if (!hasTranslated) {
        listLangSendToGemini.add(lang);
      }
    }
    if (listLangSendToGemini.isNotEmpty) {
      await sendToGenmini(msg: widget.message, languages: listLangSendToGemini)
          .then((map) {
        for (var e in map.entries) {
          //_resultTranslations add them data
          _resultTranslations[e.key] = e.value;
        }
        FirebaseFirestore.instance.collection('translations').doc(widget.id).set(
            map,
            SetOptions(
                merge: true)); //nếu key đã có rồi thì ko thay đổi, chưa thì add
      });
    }
    return _resultTranslations;
  }
}

extension on List<String> {
  //tính luôn cả trường hợp giống nhau nhưng ko đúng thứ tự
  bool equal(List<String> selectedLanguages) {
    // if (this == null) return false;
    if (isEmpty || selectedLanguages.isEmpty) return false;
    for (String e in this) {
      if (!selectedLanguages.contains(e)) {
        return false;
      }
    }
    print('equal: $selectedLanguages');
    return true;
  }
}

class _DefaultPersonWidget extends StatelessWidget {
  const _DefaultPersonWidget();

  @override
  Widget build(BuildContext context) => const Icon(
        Icons.person,
        color: Colors.black,
        size: 20,
      );
}
