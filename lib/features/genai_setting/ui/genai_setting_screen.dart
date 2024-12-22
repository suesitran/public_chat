import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/genai_setting/data/chat_content.dart';
import 'package:public_chat/features/genai_setting/bloc/genai_bloc.dart';
import 'package:public_chat/features/genai_setting/ui/widgets/gen_ai_chat_bubble.dart';

import '../../../_shared/widgets/message_box_widget.dart' show MessageBox;

class GenaiSettingScreen extends StatefulWidget {
  const GenaiSettingScreen(
      {super.key,
      this.isFullScreen = false,
      required this.onTapFullScreen,
      required this.onTapClose});
  final bool isFullScreen;
  final Function() onTapFullScreen;
  final Function() onTapClose;
  @override
  State<GenaiSettingScreen> createState() => _GenaiSettingScreenState();
}

class _GenaiSettingScreenState extends State<GenaiSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(),
          Expanded(child:
              BlocBuilder<GenaiBloc, GenaiState>(builder: (context, state) {
            final List<ChatContent> data = [];

            if (state is MessagesUpdate) {
              data.addAll(state.contents);
            }

            return ListView(
              reverse: true,
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
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: widget.isFullScreen
            ? BorderRadius.zero
            : const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Gemini AI",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                    widget.isFullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: Colors.white),
                onPressed: () {
                  widget.onTapFullScreen();
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  widget.onTapClose();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
