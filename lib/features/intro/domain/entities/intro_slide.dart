import 'package:equatable/equatable.dart';

class IntroSlide extends Equatable {
  const IntroSlide({
    required this.overline,
    required this.title,
    required this.body,
    required this.illustration,
  });

  final String overline;
  final String title;
  final String body;
  final String illustration;

  @override
  List<Object?> get props => <Object?>[overline, title, body, illustration];
}
