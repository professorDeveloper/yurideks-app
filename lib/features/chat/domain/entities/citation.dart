import 'package:equatable/equatable.dart';

class Citation extends Equatable {
  const Citation({
    required this.id,
    required this.source,
    required this.article,
    required this.title,
  });

  final String id;
  final String source;
  final String article;
  final String title;

  @override
  List<Object?> get props => <Object?>[id, source, article, title];
}
