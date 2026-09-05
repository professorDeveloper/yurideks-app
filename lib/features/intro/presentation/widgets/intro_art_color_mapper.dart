import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

@immutable
class IntroArtColorMapper extends ColorMapper {
  const IntroArtColorMapper({
    required this.ink,
    required this.line,
    required this.surface,
    required this.accent,
  });

  static const Color inkToken = Color(0xFF1A1A1A);
  static const Color lineToken = Color(0xFFE7E0D8);
  static const Color surfaceToken = Color(0xFFFFFFFF);
  static const Color accentToken = Color(0xFFE8622C);

  final Color ink;
  final Color line;
  final Color surface;
  final Color accent;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    return switch (color) {
      inkToken => ink,
      lineToken => line,
      surfaceToken => surface,
      accentToken => accent,
      _ => color,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is IntroArtColorMapper &&
        other.ink == ink &&
        other.line == line &&
        other.surface == surface &&
        other.accent == accent;
  }

  @override
  int get hashCode => Object.hash(ink, line, surface, accent);
}
