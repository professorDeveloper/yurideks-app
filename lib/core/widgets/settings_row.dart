import 'package:flutter/material.dart';

import '../constants/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/haptics.dart';
import 'app_icon.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.icon,
    required this.title,
    this.value,
    this.trailing,
    this.onTap,
    this.isDanger = false,
    super.key,
  });

  final String icon;
  final String title;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color tint = isDanger ? colors.danger : colors.ink;

    final Widget body = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg - 2,
      ),
      child: Row(
        children: <Widget>[
          AppIcon(
            icon,
            size: 19,
            color: isDanger ? colors.danger : colors.muted,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyStrong.copyWith(
                color: tint,
                fontSize: 15,
              ),
            ),
          ),
          if (value != null) ...<Widget>[
            const SizedBox(width: AppSpacing.md),
            Text(
              value!,
              style: AppTypography.bodySmall.copyWith(color: colors.muted),
            ),
          ],
          if (trailing != null) ...<Widget>[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ] else if (onTap != null) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            AppIcon(AppIcons.chevronRight, size: 17, color: colors.muted),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return body;
    }
    return InkWell(
      onTap: () {
        Haptics.tap();
        onTap!.call();
      },
      splashColor: colors.ink.withValues(alpha: 0.05),
      highlightColor: colors.ink.withValues(alpha: 0.035),
      child: body,
    );
  }
}
