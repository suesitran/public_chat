import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/repository/database.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/bloc_extensions.dart';

part 'user_manager_state.dart';

class UserManagerCubit extends Cubit<UserManagerState> {
  UserManagerCubit() : super(UserManagerInitial());

  void queryUserDetail(String uid) async {
    final DocumentSnapshot<UserDetail> userDetail =
        await ServiceLocator.instance.get<Database>().getUser(uid);

    emitSafely(UserDetailState(
        uid: uid,
        photoUrl: userDetail.data()?.photoUrl,
        displayName: userDetail.data()?.displayName));
  }
}
