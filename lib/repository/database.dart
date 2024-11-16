import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  final String _textDisplayed = "displayed";

  void writePublicMessage(Message message) {
    FirebaseFirestore.instance.collection(_publicRoom).add(message.toMap());
  }

  // Update the translated message of message[id] in the Firestore collection
  void updateTranslatePublicMessage(MessageTranslate message) {
    FirebaseFirestore.instance
        .collection(_publicRoom)
        .doc(message.id)
        .set(message.toMap(), SetOptions(merge: true));
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

  Future<void> saveUser(User user) async {
    final userDetail = UserDetail.fromFirebaseUser(user);
    FirebaseFirestore.instance
        .collection(_userList)
        .doc(user.uid)
        .set(userDetail.toFirestoreMap(), SetOptions(merge: true));
  }

  Future<void> updateUserLanguage(String uid, String language) async {
    await FirebaseFirestore.instance
        .collection(_userList)
        .doc(uid)
        .update({'userLanguage': language});
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

  // Save application text data to Firestore
  Future<void> setTextDisplayApplication(
      String language, Map<String, dynamic> textData) async {
    try {
      await FirebaseFirestore.instance
          .collection(_textDisplayed)
          .doc(language) // Use the language code as the document ID
          .set(textData, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print("Error updating text data for $language: $e");
      }
    }
  }

  // get application text data from Firestore
  Future<Map<String, dynamic>?> getTextDisplayApplication(
      String language) async {
    try {
      // Fetch the document for the user language
      final docSnapshot = await FirebaseFirestore.instance
          .collection(_textDisplayed)
          .doc(language)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          if (kDebugMode) {
            print("Text data for $language fetched successfully: $data");
          }
        }
        return data;
      } else {
        // Return null if no data exists for the given language
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching text data for $language: $e");
      }
      return null;
    }
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
