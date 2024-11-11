import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';

extension UserPhotoUrl on Message {
  Future<UserDetail?> get userDetail async {
    final DocumentSnapshot<UserDetail> snapshot =
        await ServiceLocator.instance.get<Database>().getUser(sender);

    if (!snapshot.exists) {
      return null;
    }

    final UserDetail? user = snapshot.data();
    if (user == null) {
      return null;
    }

    return user;
  }
}

extension StringExtension on String? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
}

extension ListExtension on List<dynamic>? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
}
