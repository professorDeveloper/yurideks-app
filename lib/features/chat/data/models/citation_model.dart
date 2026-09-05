import '../../domain/entities/citation.dart';

class CitationModel extends Citation {
  const CitationModel({
    required super.id,
    required super.source,
    required super.article,
    required super.title,
  });

  factory CitationModel.fromJson(Map<String, dynamic> json) {
    return CitationModel(
      id: json['id'] as String,
      source: json['code'] as String,
      article: json['number'] as String,
      title: json['title'] as String,
    );
  }
}
