import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/models/entities/language_entity.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'user_manager_state.dart';

class UserManagerCubit extends Cubit<UserManagerState> {
  UserManagerCubit() : super(const UserManagerState());
  final Database database = ServiceLocator.instance.get<Database>();

  Future<void> queryUserDetail(String uid) async {
    final DocumentSnapshot<UserDetail> userDetail =
        await ServiceLocator.instance.get<Database>().getUser(uid);

    emitSafely(state.copyWith(
      uid: uid,
      photoUrl: userDetail.data()?.photoUrl,
      displayName: userDetail.data()?.displayName,
      chatLanguage: userDetail.data()?.chatLanguage,
    ));
  }

  Future<void> updateUserChatLanguage(LanguageEntity languageEntity) async {
    if (state.uid == null) {
      return;
    }
    await database.updateUser(state.uid!, {
      "chatLanguage": languageEntity.toJson(),
    });
    await queryUserDetail(state.uid!);
  }
}
