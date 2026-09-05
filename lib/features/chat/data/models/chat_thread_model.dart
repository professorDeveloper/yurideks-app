import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_thread.dart';
import 'chat_message_model.dart';

class ChatThreadModel extends ChatThread {
  const ChatThreadModel({
    required super.id,
    required super.title,
    required super.messages,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadModel(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: _messages(json['messages']),
    );
  }

  static List<ChatMessage> _messages(Object? raw) {
    if (raw is! List<dynamic>) {
      return const <ChatMessage>[];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(ChatMessageModel.fromJson)
        .toList(growable: false);
  }
}
