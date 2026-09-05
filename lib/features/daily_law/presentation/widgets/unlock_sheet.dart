import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mystery_box.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';

class UnlockSheet extends StatelessWidget {
  const UnlockSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.md,
        AppSpacing.screen,
        AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              height: 4,
              width: 44,
              decoration: BoxDecoration(
                color: colors.line,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Center(child: MysteryBox(size: 150, glow: 0.8)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.dailyUnlockTitle,
            textAlign: TextAlign.center,
            style: AppTypography.title.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.dailyUnlockBody,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: AppStrings.dailyUnlockPrice,
            leadingIcon: AppIcons.lock,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: AppStrings.dailyLater,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
