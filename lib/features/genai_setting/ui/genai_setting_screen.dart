import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/genai_setting/data/chat_content.dart';
import 'package:public_chat/features/genai_setting/bloc/genai_bloc.dart';
import 'package:public_chat/features/genai_setting/ui/widgets/gen_ai_chat_bubble.dart';

import '../../../_shared/widgets/chat/message_box_widget.dart' show MessageBox;

class GenaiSettingScreen extends StatelessWidget {
  const GenaiSettingScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Column(
          children: [
            Expanded(child:
                BlocBuilder<GenaiBloc, GenaiState>(builder: (context, state) {
              final List<ChatContent> data = [];

              if (state is MessagesUpdate) {
                data.addAll(state.contents);
              }

              return ListView(
                children: data.map((e) {
                  final bool isMine = e.sender == Sender.user;
                  return GenAIChatBubble(
                      isMine: isMine, photoUrl: null, message: e.message);
                }).toList(),
              );
            })),
            MessageBox(
              onSendMessage: (value) {
                context.read<GenaiBloc>().add(SendMessageEvent(value));
              },
            )
          ],
        )),
      );
}
