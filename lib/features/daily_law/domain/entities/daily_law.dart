import 'package:equatable/equatable.dart';

class DailyLaw extends Equatable {
  const DailyLaw({
    required this.id,
    required this.topic,
    required this.title,
    required this.summary,
    required this.steps,
    required this.source,
    required this.article,
  });

  final String id;
  final String topic;
  final String title;
  final String summary;
  final List<String> steps;
  final String source;
  final String article;

  @override
  List<Object?> get props => <Object?>[
        id,
        topic,
        title,
        summary,
        steps,
        source,
        article,
      ];
}
