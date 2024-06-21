import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/bloc/file_picker_cubit.dart';
import 'package:public_chat/bloc/genai_cubit.dart';
import 'package:public_chat/features/home/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FilePickerCubit>(
          create: (context) => FilePickerCubit(),
        ),
        BlocProvider<GenaiCubit>(
          create: (context) => GenaiCubit(),
        )
      ],
      child: MaterialApp(home: HomeScreen()),
    );
  }
}
