import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:public_chat/_shared/data/chat_data.dart';

final class Database {
  static Database? _instance;

  Database._();

  static Database get instance {
    _instance ??= Database._();
    return _instance!;
  }

  final String _publicRoom = 'public';
  final String _userList = 'users';
  final String _languageList = 'languages';

  void writePublicMessage(Message message) {
    FirebaseFirestore.instance.collection(_publicRoom).add(message.toMap());
  }

  Query<T> getPublicChatContents<T>({
    required FromFirestore<T> fromFirestore,
    required ToFirestore<T> toFirestore,
  }) {
    return FirebaseFirestore.instance
        .collection(_publicRoom)
        .orderBy('time', descending: true)
        .withConverter(fromFirestore: fromFirestore, toFirestore: toFirestore);
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
            fromFirestore: _userDetailFromFirestore,
            toFirestore: _userDetailToFirestore)
        .get(const GetOptions(source: Source.serverAndCache));
  }

  Stream<QuerySnapshot<UserDetail>> getUserStream() {
    return FirebaseFirestore.instance
        .collection(_userList)
        .withConverter(
            fromFirestore: _userDetailFromFirestore,
            toFirestore: _userDetailToFirestore)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTranslationStream(
      String messageId) {
    return FirebaseFirestore.instance
        .collection('public')
        .doc(messageId)
        .collection('translations')
        .orderBy('index')
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTranslationNoStream(
      String messageId) {
    return FirebaseFirestore.instance
        .collection('public')
        .doc(messageId)
        .collection('translations_nostream')
        .get();
  }
  Future<bool> checkTranslationNoStreamExists(String messageId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('public')
        .doc(messageId)
        .get(); // Lấy tài liệu chính

    // Kiểm tra xem tài liệu có tồn tại và trường translations_nostream có giá trị không
    if (docSnapshot.exists) {
        final translationsNoStream = docSnapshot.data()?['translations_nostream'];
        return translationsNoStream != null && translationsNoStream is String && translationsNoStream.isNotEmpty;
    }
    return false; // Tài liệu không tồn tại
}

  void addLanguage(List<String> languages) async {
    final collection = FirebaseFirestore.instance.collection(_languageList);
    // collection.add({'language_list': languages});
    // for (var language in languages) {
      final existingLanguage =
          await collection.where('language_list', isEqualTo: languages).get();
      if (existingLanguage.docs.isEmpty) {
        collection.add({'language_list': languages});
      }
    // }
  }

  /// ###############################################################
  /// fromFirestore and toFirestore
  UserDetail _userDetailFromFirestore(
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
