import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:public_chat/extensions/bloc_extensions.dart';

import '../data/chat_data.dart';

part 'file_picker_state.dart';

class FilePickerCubit extends Cubit<FilePickerState> {
  FilePickerCubit() : super(FilePickerIdle());

  void pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List data = await result.files.single.xFile.readAsBytes();

      emitSafely(FilePicked(MemoryData(data, DataType.image)));
    } else {
      emitSafely(UserCancelled());
    }
  }

  void clear() {
    emitSafely(FilePickerIdle());
  }
}
