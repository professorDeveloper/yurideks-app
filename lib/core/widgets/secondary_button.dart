import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/haptics.dart';
import 'app_icon.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.compact = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? leadingIcon;
  final String? trailingIcon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final bool isEnabled = onPressed != null;
    final Color foreground =
        isEnabled ? colors.ink : colors.muted.withValues(alpha: 0.6);
    final BorderRadius radius = BorderRadius.circular(AppRadius.button);

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: Material(
        color: colors.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isEnabled
              ? () {
                  Haptics.tap();
                  onPressed!.call();
                }
              : null,
          splashColor: colors.ink.withValues(alpha: 0.06),
          highlightColor: colors.ink.withValues(alpha: 0.045),
          child: Container(
            height: compact ? 44 : 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: colors.line, width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (leadingIcon != null) ...<Widget>[
                  AppIcon(leadingIcon!, size: 18, color: foreground),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  label,
                  style: AppTypography.button.copyWith(color: foreground),
                ),
                if (trailingIcon != null) ...<Widget>[
                  const SizedBox(width: AppSpacing.sm),
                  AppIcon(trailingIcon!, size: 18, color: foreground),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
