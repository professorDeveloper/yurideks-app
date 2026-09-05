import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_icon.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({
    required this.collected,
    required this.total,
    required this.streak,
    super.key,
  });

  final int collected;
  final int total;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.line),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Expanded(
              child: _Stat(
                icon: AppIcons.collection,
                value: '$collected/$total',
                label: AppStrings.profileCollected,
              ),
            ),
            VerticalDivider(
                color: colors.line, width: 1, indent: 4, endIndent: 4),
            Expanded(
              child: _Stat(
                icon: AppIcons.streak,
                value: '$streak',
                label: '${AppStrings.profileStreak} ${AppStrings.profileDays}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label});

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Column(
      children: <Widget>[
        AppIcon(icon, size: 18, color: colors.accent),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: AppTypography.headline.copyWith(
            color: colors.ink,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
