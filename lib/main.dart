import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/genai_setting/bloc/genai_bloc.dart';
import 'package:public_chat/data/chat_content.dart';
import 'package:public_chat/features/genai_setting/ui/genai_setting_screen.dart';
import 'package:public_chat/firebase_options.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/features/genai_setting/ui/widgets/chat_bubble_widget.dart';
import 'package:public_chat/features/genai_setting/ui/widgets/message_box_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  ServiceLocator.instance.initialise();

  runApp(BlocProvider<GenaiBloc>(
    create: (context) => GenaiBloc(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GenaiSettingScreen()
    );
  }
}
