part of 'file_picker_cubit.dart';

sealed class FilePickerState extends Equatable {
  const FilePickerState();
}

final class FilePickerIdle extends FilePickerState {
  @override
  List<Object> get props => [];
}

final class FilePicked extends FilePickerState {
  final MemoryData data;

  const FilePicked(this.data);

  @override
  List<Object?> get props => [data.type, data.data.length, ...data.data];
}

final class FileNotFound extends FilePickerState {
  final String filePath;

  const FileNotFound(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

final class UserCancelled extends FilePickerState {
  @override
  List<Object?> get props => [];
}
