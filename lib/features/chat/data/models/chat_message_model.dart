import '../../domain/entities/chat_message.dart';
import '../../domain/entities/citation.dart';
import 'citation_model.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.author,
    required super.content,
    super.citations,
    super.needsEscalation,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      author: _author(json['author'] as String?),
      content: json['content'] as String,
      citations: _citations(json['citations']),
      needsEscalation: json['needsEscalation'] as bool? ?? false,
    );
  }

  static const String _citizenAuthor = 'CITIZEN';

  static MessageAuthor _author(String? raw) {
    return raw == _citizenAuthor
        ? MessageAuthor.citizen
        : MessageAuthor.assistant;
  }

  static List<Citation> _citations(Object? raw) {
    if (raw is! List<dynamic>) {
      return const <Citation>[];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(CitationModel.fromJson)
        .toList(growable: false);
  }
}
