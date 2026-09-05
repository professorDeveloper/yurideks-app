abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double screen = 24;
}

abstract final class AppRadius {
  static const double xs = 6;
  static const double button = 12;
  static const double sm = 12;
  static const double field = 14;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 26;
  static const double pill = 999;
}

abstract final class AppDuration {
  static const Duration instant = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration base = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 460);
  static const Duration splash = Duration(milliseconds: 2900);
  static const Duration otpResendWindow = Duration(seconds: 60);
}
