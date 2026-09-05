import 'package:equatable/equatable.dart';

import 'chat_message.dart';

class ChatThread extends Equatable {
  const ChatThread({
    required this.id,
    required this.title,
    required this.messages,
  });

  final String id;
  final String title;
  final List<ChatMessage> messages;

  @override
  List<Object?> get props => <Object?>[id, title, messages];
}
