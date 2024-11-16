import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/_shared/bloc/user_manager/user_manager_cubit.dart';
import 'package:public_chat/_shared/data/chat_data.dart';
import 'package:public_chat/_shared/widgets/chat/components/item_left_view.dart';
import 'package:public_chat/_shared/widgets/chat/components/item_right_view.dart';
import 'package:public_chat/features/genai_setting/data/user_message_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final User? user;
  final double iconSize;

  const ChatBubble({
    super.key,
    required this.message,
    required this.user,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserManagerCubit>.value(
      value: UserManagerCubit()..queryUserDetail(message.sender),
      child: BlocBuilder<UserManagerCubit, UserManagerState>(
        builder: (context, state) {
          String? photoUrl;
          String? displayName;

          if (state is UserDetailState) {
            photoUrl = state.photoUrl;
            displayName = state.displayName;
          }
          final model = UserMessageModel(
              iconSize: iconSize,
              photoUrl: photoUrl,
              translations: message.translations,
              displayName: displayName,
              message: message.message,
              messageId: message.id);
          final isMine = message.sender == user?.uid;
          if (isMine) {
            return ItemRightView(model: model);
          }
          return ItemLeftView(model: model);
        },
      ),
    );
  }
}
