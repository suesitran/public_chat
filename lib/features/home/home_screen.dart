import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/bloc/genai_cubit.dart';
import 'package:public_chat/data/chat_data.dart';

import '../../widgets/chat_bubble_widget.dart';
import '../../widgets/message_box_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ValueNotifier<List<ChatContent>> _contents = ValueNotifier([
    ChatContent.user(ChatData.text('This is a message from user')),
    ChatContent.gemini(ChatData.text('This is a message from Gemini'))
  ]);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Column(
          children: [
            Expanded(
                child: ValueListenableBuilder<List<ChatContent>>(
              valueListenable: _contents,
              builder: (context, content, child) => ListView(
                children: content
                    .map((e) => ChatBubble(e.sender, null, e.message))
                    .toList(),
              ),
            )),
            MessageBox(
              onSendMessage: (message, file) {},
            )
          ],
        )),
      );
}
