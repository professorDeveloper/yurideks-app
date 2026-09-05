import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static SystemUiOverlayStyle overlayStyle(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          isDark ? AppColors.dark.background : AppColors.light.background,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );
  }

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: colors.accent,
      onPrimary: colors.accentInk,
      primaryContainer: colors.accentSoft,
      onPrimaryContainer: colors.accent,
      secondary: colors.ink,
      onSecondary: colors.background,
      error: colors.danger,
      onError: colors.accentInk,
      surface: colors.surface,
      onSurface: colors.ink,
      onSurfaceVariant: colors.muted,
      outline: colors.line,
    );

    final TextTheme textTheme = TextTheme(
      displaySmall: AppTypography.display.copyWith(color: colors.ink),
      headlineMedium: AppTypography.headline.copyWith(color: colors.ink),
      titleLarge: AppTypography.title.copyWith(color: colors.ink),
      bodyLarge: AppTypography.body.copyWith(color: colors.ink),
      bodyMedium: AppTypography.body.copyWith(color: colors.muted),
      labelLarge: AppTypography.label.copyWith(color: colors.ink),
      labelMedium: AppTypography.caption.copyWith(color: colors.muted),
      labelSmall: AppTypography.overline.copyWith(color: colors.muted),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      extensions: <ThemeExtension<dynamic>>[colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: overlayStyle(brightness),
        titleTextStyle: AppTypography.title.copyWith(color: colors.ink),
        iconTheme: IconThemeData(color: colors.ink, size: 22),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.accent,
        selectionColor: colors.accent.withValues(alpha: 0.24),
        selectionHandleColor: colors.accent,
      ),
      dividerTheme: DividerThemeData(
        color: colors.line,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.ink,
        contentTextStyle:
            AppTypography.label.copyWith(color: colors.background),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
