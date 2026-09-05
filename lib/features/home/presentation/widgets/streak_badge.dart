import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_icon.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({required this.days, super.key});

  final int days;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppIcon(AppIcons.streak, size: 15, color: colors.accent),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$days ${AppStrings.dailyStreakSuffix}',
            style: AppTypography.label.copyWith(
              color: colors.accent,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
