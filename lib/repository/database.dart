import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/constants.dart';
import 'package:translator/translator.dart';

final class Database {
  static Database? _instance;

  Database._();

  static Database get instance {
    _instance ??= Database._();
    return _instance!;
  }

  final String _publicRoom = 'public';
  final String _userList = 'users';

  Future<void> translateMessageByCurrentLanguageCode(
    String languageCode,
  ) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(_publicRoom);
    QuerySnapshot querySnapshot = await collectionRef.get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    int batchLength = 0;
    await Future.forEach(querySnapshot.docs, (doc) async {
      Map<String, String> translated =
          (doc.data() as Map<String, dynamic>)['translated'];
      if (!translated.keys.contains(languageCode)) {
        if (translated.keys.contains(Constants.languageCodeDefault)) {
          final translator = ServiceLocator.instance.get<GoogleTranslator>();
          final messageTranslated = await translator.translate(
              translated[Constants.languageCodeDefault]!,
              from: Constants.languageCodeDefault,
              to: languageCode);
          translated[languageCode] = messageTranslated.text;
        }
      }
      batch.update(doc.reference, {'translated': translated});
      batchLength++;
      if (batchLength == Constants.lengthBatchUpdateTranslateMessage) {
        await batch.commit();
        batch = FirebaseFirestore.instance.batch();
      }
    });
    await batch.commit();
  }

  void writePublicMessage(Message message) {
    FirebaseFirestore.instance.collection(_publicRoom).add(message.toMap());
  }

  Query<T> getPublicChatContents<T>({
    required FromFirestore<T> fromFireStore,
    required ToFirestore<T> toFireStore,
  }) {
    return FirebaseFirestore.instance
        .collection(_publicRoom)
        .orderBy('time', descending: true)
        .withConverter(fromFirestore: fromFireStore, toFirestore: toFireStore);
  }

  void saveUser(User user) {
    final UserDetail userDetail = UserDetail.fromFirebaseUser(user);
    FirebaseFirestore.instance
        .collection(_userList)
        .doc(user.uid)
        .set(userDetail.toMap(), SetOptions(merge: true));
  }

  Future<DocumentSnapshot<UserDetail>> getUser(String uid) {
    return FirebaseFirestore.instance
        .collection(_userList)
        .doc(uid)
        .withConverter(
            fromFirestore: _userDetailFromFireStore,
            toFirestore: _userDetailToFirestore)
        .get(const GetOptions(source: Source.serverAndCache));
  }

  Stream<QuerySnapshot<UserDetail>> getUserStream() {
    return FirebaseFirestore.instance
        .collection(_userList)
        .withConverter(
            fromFirestore: _userDetailFromFireStore,
            toFirestore: _userDetailToFirestore)
        .snapshots();
  }

  /// ###############################################################
  /// fromFireStore and toFireStore
  UserDetail _userDetailFromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) =>
      UserDetail.fromMap(snapshot.id, snapshot.data() ?? {});

  Map<String, Object?> _userDetailToFirestore(
    UserDetail value,
    SetOptions? options,
  ) =>
      value.toMap();
}
