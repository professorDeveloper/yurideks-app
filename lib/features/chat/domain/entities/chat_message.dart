import 'package:equatable/equatable.dart';

import 'citation.dart';

enum MessageAuthor { citizen, assistant }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.author,
    required this.content,
    this.steps = const <String>[],
    this.citations = const <Citation>[],
    this.needsEscalation = false,
  });

  final String id;
  final MessageAuthor author;
  final String content;
  final List<String> steps;
  final List<Citation> citations;
  final bool needsEscalation;

  @override
  List<Object?> get props => <Object?>[
        id,
        author,
        content,
        steps,
        citations,
        needsEscalation,
      ];
}
