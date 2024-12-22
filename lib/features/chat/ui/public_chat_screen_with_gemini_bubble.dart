import 'package:flutter/material.dart';
import 'package:public_chat/features/chat/ui/public_chat_screen.dart';

import '../../genai_setting/ui/widgets/chat_with_gemini_bubble.dart';

class PublicChatScreenWithGeminiBubble extends StatefulWidget {
  const PublicChatScreenWithGeminiBubble({super.key});

  @override
  _PublicChatScreenWithGeminiBubbleState createState() =>
      _PublicChatScreenWithGeminiBubbleState();
}

class _PublicChatScreenWithGeminiBubbleState
    extends State<PublicChatScreenWithGeminiBubble> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          PublicChatScreen(),
          ChatWithGeminiBubble(),
        ],
      ),
    );
  }
}
