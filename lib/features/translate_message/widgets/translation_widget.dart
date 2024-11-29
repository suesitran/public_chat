import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TranslationsWidget extends StatefulWidget {
  const TranslationsWidget({
    super.key,
    required this.translationsNoStream,
    required this.isMine,
    required this.selectedLanguages,
    required this.subscription,
  });
  final bool isMine;
  final String? translationsNoStream;
  final List<String> selectedLanguages;
  final Stream<QuerySnapshot<Map<String, dynamic>>> subscription;
  @override
  State<TranslationsWidget> createState() => _TranslationsWidgetState();
}

class _TranslationsWidgetState extends State<TranslationsWidget> {
  @override
  void initState() {
    super.initState();
    getTranslations(
        selectedLanguages: widget.selectedLanguages,
        subscription: widget.subscription,
        translationsNoStream: widget.translationsNoStream);
  }

  @override
  void dispose() {
    _myStreamController.close();
    super.dispose();
  }

  final _myStreamController = StreamController<String>();
  void getTranslations(
      {required List<String> selectedLanguages,
      String? translationsNoStream,
      required Stream<QuerySnapshot<Map<String, dynamic>>> subscription}) {
    _myStreamController.add('Loading...');
    String text = '';
    String selectedLangsStr = selectedLanguages.toString();
    if (translationsNoStream != null && translationsNoStream.isNotEmpty) {
      int startIndex = translationsNoStream.indexOf(selectedLangsStr);
      if (startIndex == -1) {
        findEachLanguageMatchInTranslationNoStream(
            selectedLanguages, translationsNoStream, text);
      } else {
        findSelectedLanguagesInTranslationNoStream(
            translationsNoStream, startIndex, selectedLangsStr, text);
      }
    } else {
      listenToRealtimeTranslation(subscription, text, selectedLangsStr);
    }
  }

  void listenToRealtimeTranslation(
      Stream<QuerySnapshot<Map<String, dynamic>>> subscription,
      String text,
      String selectedLangsStr) {
    bool foundSelectedLanguages = false;
    int endIndex = -1;
    try {
      subscription.listen((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          final chunk = doc.data();
          text += chunk['text'];
          _myStreamController.add(text);
          if (!foundSelectedLanguages) {
            int startIndex = text.indexOf(selectedLangsStr);
            if (startIndex != -1) {
              text = text.substring(startIndex + selectedLangsStr.length);
              _myStreamController.add(text);
              foundSelectedLanguages = true;
            }
          } else {
            endIndex = text.indexOf('[');
            if (endIndex != -1) {
              break;
            }
          }
        }
      }, onError: (error) {
        debugPrint('onError: $error');
      });
    } catch (e) {
      debugPrint('catch error: $e');
    }
    //remove the last characters that's not related to result
    if (endIndex != -1) {
      text = text.substring(0, endIndex);
      _myStreamController.add(text);
    }
  }

  void findSelectedLanguagesInTranslationNoStream(String translationsNoStream,
      int startIndex, String selectedLangsStr, String text) {
    String result =
        translationsNoStream.substring(startIndex + selectedLangsStr.length);
    int endIndex = result.indexOf('[');
    if (endIndex == -1) {
      text += result;
      _myStreamController.add(text);
    } else {
      text += result.substring(0, endIndex);
      _myStreamController.add(text);
    }
  }

  void findEachLanguageMatchInTranslationNoStream(
      List<String> selectedLanguages,
      String translationsNoStream,
      String text) {
    for (var lang in selectedLanguages) {
      int index = translationsNoStream.indexOf('<b>$lang</b>');
      if (index != -1) {
        String result = translationsNoStream.substring(index);
        int endIndex = result.indexOf('<br>');
        if (endIndex != -1) {
          text += result.substring(0, endIndex);
          _myStreamController.add(text);
        }
      } else {
        text += '<br>Not found $lang';
        _myStreamController.add(text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _myStreamController.stream,
      builder: (context, snapshot) {
        return HtmlWidget(
            '<div style="color: white;">${snapshot.data ?? 'Loading translations...'}</div>');
      },
    );
  }
}
