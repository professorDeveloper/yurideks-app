import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/bird_mark.dart';

class ChatEmpty extends StatelessWidget {
  const ChatEmpty({required this.onPick, super.key});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.huge,
        AppSpacing.screen,
        AppSpacing.xl,
      ),
      children: <Widget>[
        const Center(child: BirdMark(height: 54)),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppStrings.chatEmptyTitle,
          textAlign: TextAlign.center,
          style: AppTypography.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppStrings.chatEmptyBody,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.xxl),
        for (final String suggestion in AppStrings.chatSuggestions)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: GestureDetector(
              onTap: () {
                Haptics.tap();
                onPick(suggestion);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: colors.line),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        suggestion,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.ink,
                        ),
                      ),
                    ),
                    AppIcon(AppIcons.arrowUpRight,
                        size: 17, color: colors.muted),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.chatDisclaimer,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(
            color: colors.muted.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
