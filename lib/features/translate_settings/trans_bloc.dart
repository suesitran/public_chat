import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:public_chat/utils/bloc_extensions.dart';
import 'package:public_chat/utils/local_shared_data.dart';

import '../../_shared/dialog/message_dialog.dart';
part 'trans_event.dart';
part 'trans_state.dart';

class TransBloc extends Bloc<TransEvent, TransState> {
  final LocalSharedData _localSharedData = LocalSharedData();
  TransBloc() : super(TransInit()) {
    on<SelectLanguageEvent>(_onSelectLanguage);
    on<LoadHistoryLanguagesEvent>(_onLoadHistoryLanguages);
  }
  Future<void> _onSelectLanguage(
    SelectLanguageEvent event,
    Emitter<TransState> emit,
  ) async {
    _localSharedData.setChatLanguages(event.languages);
    emitSafely(ChangeLangState(
      selectedLanguages: event.languages,
    ));
  }

  Map<String, dynamic> _resultTranslations = {};
  List<String> _previousLanguages = [];
  void getTranslations(
      {required String message,
      required List<String> selectedLanguages,
      required String messageID}) async {
    emitSafely(TransLoading());
    final _firebaseInstance = FirebaseFirestore.instance;
    // final _firebaseInstance = ServiceLocator.get<FirebaseFirestore>();
    //nếu có lang dịch rồi, lang chưa: vẫn lấy "translations" từ firestore vì lang dịch rồi đó sẽ có trên firebase
    if (_previousLanguages.equal(selectedLanguages)) {
      emitSafely(TransResult(resultTranslations: _resultTranslations));
    } else {
      _previousLanguages = selectedLanguages;
      _resultTranslations = {}; //cp reset
    }
    //get translations from firestore
    //TODO: use ServiceLocator
    DocumentSnapshot<Map<String, dynamic>> data =
        await _firebaseInstance.collection('translations').doc(messageID).get();
    //neu id chua exist, them vao firestore
    if (!data.exists) {
      await _firebaseInstance
          .collection('translations')
          .doc(messageID)
          .set({'id ko ton tai': 'id ko ton tai => them moi'});
      data = await _firebaseInstance
          .collection('translations')
          .doc(messageID)
          .get();
    }
    Map<String, dynamic> translations = data.data() ?? {};
    List<String> listLangSendToGemini = [];
    for (String lang in selectedLanguages) {
      bool hasTranslated = false;
      for (var e in translations.entries) {
        if (lang.toLowerCase() == e.key.toLowerCase()) {
          _resultTranslations[lang] = "translated: " +
              e.value; //đã có trên firestore rồi, ko cần dịch nữa
          hasTranslated = true;
          break;
        }
      }
      if (!hasTranslated) {
        listLangSendToGemini.add(lang);
      }
    }
    if (listLangSendToGemini.isNotEmpty) {
      await sendToGenmini(msg: message, languages: listLangSendToGemini)
          .then((map) {
        for (var e in map.entries) {
          //_resultTranslations add them data
          _resultTranslations[e.key] = e.value;
        }
        _firebaseInstance.collection('translations').doc(messageID).set(
            map,
            SetOptions(
                merge: true)); //nếu key đã có rồi thì ko thay đổi, chưa thì add
      });
    }
    emitSafely(TransResult(resultTranslations: _resultTranslations));
  }

  Future<Map<String, dynamic>> sendToGenmini({
    required String msg,
    required List<String> languages,
  }) async {
    String? apiKey = Platform.environment['GEMINI_API_KEY'];
    if (apiKey == null) {
      stderr.writeln(r'No $GEMINI_API_KEY environment variable');
      exit(1);
    }
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );
    final generationConfig = GenerationConfig(
      temperature: 1,
      topP: 0.95,
      topK: 64,
      maxOutputTokens: 8192,
      responseMimeType: 'application/json',
      responseSchema: Schema(SchemaType.object, properties: {
        'translations': Schema(
          SchemaType.object,
          properties: Map.fromEntries(languages
              .map((lang) => MapEntry(lang, Schema(SchemaType.string)))),
          requiredProperties: languages,
        )
      }, requiredProperties: [
        'translations'
      ]),
    );
    final prompt =
        '''Translate "$msg" to these languages/language codes: ${languages.toString()},
    You must return the translations in JSON format with language codes as keys, e.g: {"en": "English translation", "fr": "French translation"}''';
    final chatSession = model.startChat(generationConfig: generationConfig);
    final result = await chatSession.sendMessage(Content.text(prompt));
    final jsonTranslated = result
        .text; // {"translations": {"en": "Hello, this is a test. I am Dương"}}
    Map<String, String>? translated;
    if (jsonTranslated != null) {
      translated = jsonDecode(jsonTranslated)['translations'];
//{en: Hello, this is a test. I am Dương}
    } else {
      MessageDialog.showError('Gemini trả về phản hồi null');
    }
    return translated ?? {};
  }

  FutureOr<void> _onLoadHistoryLanguages(
      LoadHistoryLanguagesEvent event, Emitter<TransState> emit) {
    emitSafely(TransInit());
    final listHistoryLanguages = _localSharedData.getListHistoryLanguages();
    emitSafely(
        LoadHistoryLanguages(listHistoryLanguages: listHistoryLanguages));
  }
}

extension on List<String> {
  //tính luôn cả trường hợp giống nhau nhưng ko đúng thứ tự
  bool equal(List<String> selectedLanguages) {
    if (isEmpty || selectedLanguages.isEmpty) return false;
    for (String e in this) {
      if (!selectedLanguages.contains(e)) {
        return false;
      }
    }
    return true;
  }
}
