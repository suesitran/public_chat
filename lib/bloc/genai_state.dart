part of 'genai_cubit.dart';

sealed class GenaiState extends Equatable {
  const GenaiState();
}

final class GenaiInitial extends GenaiState {
  @override
  List<Object> get props => [];
}

final class UserMessage extends GenaiState {
  final String message;

  const UserMessage(this.message);

  @override
  List<Object?> get props => [message];
}

final class GeminiMessage extends GenaiState {
  final String message;

  const GeminiMessage(this.message);

  @override
  List<Object?> get props => [message];
}
