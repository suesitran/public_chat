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
                child: StreamBuilder<List<ChatContent>>(
                    stream: _worker.stream,
                    builder: (context, snapshot) {
                      final List<ChatContent> data = snapshot.data ?? [];
                      return ListView(
                        children: data.map((e) {
                          final bool isMine = e.sender == Sender.user;
                          return ChatBubble(
                              isMine: isMine,
                              photoUrl: null,
                              message: e.message);
                        }).toList(),
                      );
                    })),
            MessageBox(
              onSendMessage: (value) {
                // TODO send message to Gemini
                _worker.sendToGemini(value);
              },
            )
          ],
        )),
      ),
    );
  }
}
