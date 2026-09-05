import '../../domain/entities/daily_law.dart';

const Map<String, String> _topicLabels = <String, String>{
  'LABOR': 'Mehnat huquqi',
  'CONSUMER': 'Iste’molchi huquqi',
  'FAMILY': 'Oila huquqi',
  'CIVIL': 'Fuqarolik huquqi',
  'ADMIN_LIABILITY': 'Ma’muriy javobgarlik',
};

const String _fallbackTopicLabel = 'Huquq';
const int _maxDerivedSteps = 3;

final RegExp _sentenceBreak = RegExp(r'(?<=[.!?])\s+');

String _topicLabelOf(Object? raw) => _topicLabels[raw] ?? _fallbackTopicLabel;

List<String> _sentencesOf(String body) {
  return body
      .split(_sentenceBreak)
      .map((String part) => part.trim())
      .where((String part) => part.isNotEmpty)
      .toList(growable: false);
}

class DailyLawModel extends DailyLaw {
  const DailyLawModel({
    required super.id,
    required super.topic,
    required super.title,
    required super.summary,
    required super.steps,
    required super.source,
    required super.article,
  });

  factory DailyLawModel.fromJson(Map<String, dynamic> json) {
    return DailyLawModel(
      id: json['id'] as String,
      topic: json['topic'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      steps: (json['steps'] as List<dynamic>).cast<String>(),
      source: json['source'] as String,
      article: json['article'] as String,
    );
  }

  factory DailyLawModel.fromLawArticleJson(Map<String, dynamic> json) {
    final String body = json['body'] as String;
    final List<String> sentences = _sentencesOf(body);
    return DailyLawModel(
      id: json['id'] as String,
      topic: _topicLabelOf(json['topic']),
      title: json['title'] as String,
      summary: sentences.isEmpty ? body : sentences.first,
      steps: sentences.skip(1).take(_maxDerivedSteps).toList(growable: false),
      source: json['code'] as String,
      article: json['number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'topic': topic,
      'title': title,
      'summary': summary,
      'steps': steps,
      'source': source,
      'article': article,
    };
  }
}
