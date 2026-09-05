import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/haptics.dart';
import 'app_icon.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.compact = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? leadingIcon;
  final String? trailingIcon;
  final bool compact;

  bool get _isEnabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color background = _isEnabled ? colors.accent : colors.surfaceMuted;
    final Color foreground =
        _isEnabled ? colors.accentInk : colors.muted.withValues(alpha: 0.85);
    final BorderRadius radius = BorderRadius.circular(AppRadius.button);

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: label,
      child: Material(
        color: background,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _isEnabled
              ? () {
                  Haptics.impact();
                  onPressed!.call();
                }
              : null,
          splashColor: colors.accentInk.withValues(alpha: 0.14),
          highlightColor: colors.accentInk.withValues(alpha: 0.10),
          child: Container(
            height: compact ? 44 : 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: _isEnabled
                  ? null
                  : Border.all(color: colors.inputBorder, width: 1.4),
            ),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(foreground),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (leadingIcon != null) ...<Widget>[
                        AppIcon(leadingIcon!, size: 18, color: foreground),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        label,
                        style: AppTypography.button.copyWith(
                          color: foreground,
                        ),
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
