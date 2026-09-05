import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/haptics.dart';

class TextLink extends StatelessWidget {
  const TextLink({
    required this.label,
    required this.onPressed,
    this.emphasized = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color foreground = onPressed == null
        ? colors.muted.withValues(alpha: 0.6)
        : emphasized
            ? colors.accent
            : colors.ink;

    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: InkWell(
        onTap: onPressed == null
            ? null
            : () {
                Haptics.tap();
                onPressed!.call();
              },
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Text(
            label,
            style: AppTypography.label.copyWith(
              color: foreground,
              decoration: TextDecoration.underline,
              decorationColor: foreground.withValues(alpha: 0.4),
              decorationThickness: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
