import 'package:flutter/material.dart';
import 'package:public_chat/widgets/chat_bubble_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ChatBubble(isMine: false, photoUrl: 'https://i.imgur.com/cefjdCQ.jpeg', message: 'this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me'),
              ChatBubble(isMine: true, photoUrl: 'https://i.imgur.com/cefjdCQ.jpeg', message: 'this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me this is a message from me'),
            ],
          )
        ),
      ),
    );
  }
}
