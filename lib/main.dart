import 'package:flutter/material.dart';
import 'package:public_chat/widgets/chat_bubble_widget.dart';
import 'package:public_chat/widgets/message_box_widget.dart';
import 'package:public_chat/worker/genai_worker.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final GenAIWorker _worker = GenAIWorker();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                ChatBubble(
                    isMine: false,
                    photoUrl: 'https://i.imgur.com/cefjdCQ.jpeg',
                    message:
                        'this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me'),
                ChatBubble(
                    isMine: true,
                    photoUrl: 'https://i.imgur.com/cefjdCQ.jpeg',
                    message:
                        'this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me'),
              ],
            )),
            MessageBox(
              onSendMessage: (value) {
                // TODO send message to Gemini
              },
            )
          ],
        )),
      ),
    );
  }
}
