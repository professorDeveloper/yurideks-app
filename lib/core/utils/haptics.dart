import 'package:flutter/services.dart';

abstract final class Haptics {
  static void tap() => HapticFeedback.selectionClick();

  static void impact() => HapticFeedback.lightImpact();

  static void success() => HapticFeedback.mediumImpact();

  static void error() => HapticFeedback.heavyImpact();
}
