part of 'genai_bloc.dart';

sealed class GenaiState extends Equatable {
  const GenaiState();
}

final class GenaiInitial extends GenaiState {
  @override
  List<Object> get props => [];
}

class MessagesUpdate extends GenaiState {
  final List<ChatContent> contents;

  const MessagesUpdate(this.contents);

  @override
  List<Object?> get props => [...contents, contents.length];
}
