import 'package:flutter/material.dart';
import 'package:public_chat/widgets/chat_bubble_widget.dart';
import 'package:public_chat/widgets/message_box_widget.dart';

import 'data/chat_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          children: [
            Expanded(
                child: ListView(
              // TODO implement chat UI here
              children: const [
                ChatBubble.user('Sample message from user'),
                ChatBubble.gemini('sample message from gemini')
              ],
            )),
            MessageBox(
              onSendMessage: (value) {
                // TODO send message
              },
            )
          ],
        )),
      ),
    );
  }
}
