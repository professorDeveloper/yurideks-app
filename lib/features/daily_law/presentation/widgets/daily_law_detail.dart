import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../domain/entities/daily_law.dart';

class DailyLawDetail extends StatelessWidget {
  const DailyLawDetail({required this.law, super.key});

  final DailyLaw law;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      radius: AppRadius.xl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs + 1,
            ),
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              law.topic.toUpperCase(),
              style: AppTypography.overline.copyWith(color: colors.accent),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            law.title,
            style: AppTypography.headline.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            law.summary,
            style: AppTypography.body.copyWith(color: colors.muted),
          ),
          if (law.steps.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.xl),
            Text(
              AppStrings.dailyStepsTitle,
              style: AppTypography.label.copyWith(color: colors.ink),
            ),
            const SizedBox(height: AppSpacing.md),
            for (int index = 0; index < law.steps.length; index++)
              _Step(index: index + 1, text: law.steps[index]),
          ],
          const SizedBox(height: AppSpacing.md),
          Divider(color: colors.line, height: 1),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              AppIcon(AppIcons.law, size: 15, color: colors.muted),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${AppStrings.dailySource}: ${law.source} • ${law.article}',
                  style: AppTypography.caption.copyWith(color: colors.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 22,
            width: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: AppTypography.overline.copyWith(
                color: colors.ink,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(color: colors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
