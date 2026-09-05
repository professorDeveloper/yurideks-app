import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String fontFamily = 'PlusJakartaSans';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 33,
    fontWeight: FontWeight.w800,
    height: 1.12,
    letterSpacing: -1,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.7,
  );

  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    height: 1.24,
    letterSpacing: -0.6,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.26,
    letterSpacing: -0.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.32,
    letterSpacing: -0.3,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.52,
    letterSpacing: -0.1,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.44,
    letterSpacing: -0.15,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.05,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.5,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.1,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.36,
    letterSpacing: -0.1,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.46,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 1.5,
  );

  static const TextStyle numeric = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.2,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );

  static const TextStyle input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.4,
  );

  static const TextStyle otp = TextStyle(
    fontFamily: fontFamily,
    fontSize: 23,
    fontWeight: FontWeight.w700,
    height: 1,
  );
}
