import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.inputFill,
    required this.inputBorder,
    required this.ink,
    required this.muted,
    required this.line,
    required this.accent,
    required this.accentInk,
    required this.accentDeep,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.danger,
    required this.dangerSoft,
    required this.overlay,
  });

  static const AppColors light = AppColors(
    background: Color(0xFFFAF6EF),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF3EDE4),
    inputFill: Color(0xFFFFFFFF),
    inputBorder: Color(0xFFCEC3B1),
    ink: Color(0xFF1A1A1A),
    muted: Color(0xFF6B6459),
    line: Color(0xFFE7E0D8),
    accent: Color(0xFFE8622C),
    accentInk: Color(0xFFFFFFFF),
    accentDeep: Color(0xFFC2410C),
    accentSoft: Color(0xFFFCE9DC),
    success: Color(0xFF2E7D53),
    successSoft: Color(0xFFE4F2E9),
    danger: Color(0xFFC43D2E),
    dangerSoft: Color(0xFFF9E3DF),
    overlay: Color(0x141A1A1A),
  );

  static const AppColors dark = AppColors(
    background: Color(0xFF131211),
    surface: Color(0xFF1C1A18),
    surfaceMuted: Color(0xFF232019),
    inputFill: Color(0xFF1C1A18),
    inputBorder: Color(0xFF453D34),
    ink: Color(0xFFF4F0EA),
    muted: Color(0xFFA69C90),
    line: Color(0xFF302B26),
    accent: Color(0xFFFF7038),
    accentInk: Color(0xFF1A0E07),
    accentDeep: Color(0xFFD9531C),
    accentSoft: Color(0xFF2A1C14),
    success: Color(0xFF6BCB94),
    successSoft: Color(0xFF1B2A21),
    danger: Color(0xFFFF8A72),
    dangerSoft: Color(0xFF2E1A16),
    overlay: Color(0x33000000),
  );

  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color inputFill;
  final Color inputBorder;
  final Color ink;
  final Color muted;
  final Color line;
  final Color accent;
  final Color accentInk;
  final Color accentDeep;
  final Color accentSoft;
  final Color success;
  final Color successSoft;
  final Color danger;
  final Color dangerSoft;
  final Color overlay;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? inputFill,
    Color? inputBorder,
    Color? ink,
    Color? muted,
    Color? line,
    Color? accent,
    Color? accentInk,
    Color? accentDeep,
    Color? accentSoft,
    Color? success,
    Color? successSoft,
    Color? danger,
    Color? dangerSoft,
    Color? overlay,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      inputFill: inputFill ?? this.inputFill,
      inputBorder: inputBorder ?? this.inputBorder,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      accentInk: accentInk ?? this.accentInk,
      accentDeep: accentDeep ?? this.accentDeep,
      accentSoft: accentSoft ?? this.accentSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentInk: Color.lerp(accentInk, other.accentInk, t)!,
      accentDeep: Color.lerp(accentDeep, other.accentDeep, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
