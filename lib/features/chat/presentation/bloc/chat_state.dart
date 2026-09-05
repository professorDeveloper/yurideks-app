part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => const <Object?>[];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoaded extends ChatState {
  const ChatLoaded({
    required this.messages,
    this.isThinking = false,
    this.isRestoring = false,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final bool isThinking;
  final bool isRestoring;
  final String? errorMessage;

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isThinking,
    bool? isRestoring,
    String? errorMessage,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isThinking: isThinking ?? this.isThinking,
      isRestoring: isRestoring ?? this.isRestoring,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        messages,
        isThinking,
        isRestoring,
        errorMessage,
      ];
}
