import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:public_chat/bloc/file_picker_cubit.dart';
import 'package:public_chat/gen/assets.gen.dart';

import '../data/chat_data.dart';

typedef OnSendMessage = Function(String message, MemoryData? data);

class MessageBox extends StatefulWidget {
  final OnSendMessage onSendMessage;
  final VoidCallback? onFileSelection;

  const MessageBox(
      {required this.onSendMessage, this.onFileSelection, super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final TextEditingController _controller = TextEditingController();
  MemoryData? _data;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<FilePickerCubit, FilePickerState>(
            builder: (context, state) {
              if (state is FilePicked) {
                _data = state.data;
                return SvgPicture.asset(
                  Assets.file,
                  width: 40,
                  height: 40,
                );
              }

              return const SizedBox.shrink();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // IconButton(
                //     onPressed: () {
                //       context.read<FilePickerCubit>().pickFile();
                //     },
                //     icon: const Icon(Icons.photo_album)),
                Expanded(
                    child: TextField(
                  controller: _controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: const BorderSide(
                              color: Colors.black38, width: 1.0)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                      suffixIcon: IconButton(
                        onPressed: () => _sendMessage(_controller.text),
                        icon: const Icon(Icons.send),
                      ),
                      hintText: 'Write something...',
                      hintStyle:
                          TextStyle(color: Colors.grey.withOpacity(0.5))),
                  onSubmitted: (value) => _sendMessage(value),
                ))
              ],
            ),
          )
        ],
      );

  void _sendMessage(String value) {
    widget.onSendMessage(value, _data);
    _controller.text = '';
    context.read<FilePickerCubit>().clear();
    _data = null;
  }
}
