import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/features/language_support/data/language.dart';

import 'local_language.dart';

final class Database {
  static Database? _instance;

  Database._();

  static Database get instance {
    _instance ??= Database._();
    return _instance!;
  }

  final String _publicRoom = 'public';
  final String _userList = 'users';
  final String _supportLanguage = 'support_languages';

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

  Future<UserDetail> saveUser(User user) async {
    final userData = await getUser(user.uid);
    UserDetail userDetail;
    if (userData.exists) {
      userDetail = UserDetail.fromFirebaseUser(
          user, userData.data()?.language ?? languageCodeSystem);
    } else {
      userDetail = UserDetail.fromFirebaseUser(user, languageCodeSystem);
    }
    FirebaseFirestore.instance
        .collection(_userList)
        .doc(user.uid)
        .set(userDetail.toMap(), SetOptions(merge: true));
    return userDetail;
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

  Future<List<LanguageSupport>> getLanguage() async {
    var data = await FirebaseFirestore.instance
        .collection(_supportLanguage)
        .withConverter<LanguageSupport>(
            fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot,
                SnapshotOptions? options) {
              if (snapshot.exists) {
                return LanguageSupport.fromMap(snapshot.data() ?? {});
              }
              return const LanguageSupport();
            },
            toFirestore: (LanguageSupport value, SetOptions? options) =>
                value.toMap())
        .get();
    return data.docs
        .map(
          (e) => e.data(),
        )
        .toSet()
        .toList();
  }

  void saveLanguageUser(String language) {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      FirebaseFirestore.instance
          .collection(_userList)
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({'language': language}, SetOptions(merge: true));
    }
  }

  Stream<String>? listenLanguageSettingUser() {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return FirebaseFirestore.instance
          .collection(_userList)
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .withConverter<String>(
            fromFirestore: (snapshot, options) {
              if (snapshot.exists) {
                var userData = UserDetail.fromMap(
                    FirebaseAuth.instance.currentUser!.uid,
                    snapshot.data() ?? {});
                return userData.language ?? 'en';
              }
              return '';
            },
            toFirestore: (value, options) => {},
          )
          .snapshots()
          .map(
        (event) {
          return event.data() ?? 'en';
        },
      );
    }
    return null;
  }
}
