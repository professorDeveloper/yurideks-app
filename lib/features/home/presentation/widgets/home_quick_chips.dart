import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';

class HomeQuickChips extends StatelessWidget {
  const HomeQuickChips({required this.onPick, super.key});

  static const double height = 36;

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        itemCount: AppStrings.quickQuestions.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) {
          final String question = AppStrings.quickQuestions[index];
          return Material(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Haptics.tap();
                onPick(question);
              },
              splashColor: colors.accent.withValues(alpha: 0.08),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: colors.line),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Align(
                    widthFactor: 1,
                    child: Text(
                      question,
                      style: AppTypography.label.copyWith(color: colors.ink),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
