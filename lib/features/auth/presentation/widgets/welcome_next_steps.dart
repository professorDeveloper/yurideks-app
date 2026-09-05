import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_icon.dart';

class WelcomeNextSteps extends StatelessWidget {
  const WelcomeNextSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _Step(
          icon: AppIcons.gift,
          title: AppStrings.welcomeDailyTitle,
          body: AppStrings.welcomeDailyBody,
        ),
        Divider(color: colors.line, height: 1, thickness: 1),
        const _Step(
          icon: AppIcons.chat,
          title: AppStrings.welcomeAskTitle,
          body: AppStrings.welcomeAskBody,
        ),
        Divider(color: colors.line, height: 1, thickness: 1),
        const _Step(
          icon: AppIcons.collection,
          title: AppStrings.welcomeCollectionTitle,
          body: AppStrings.welcomeCollectionBody,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.title, required this.body});

  static const double _tileSize = 34;
  static const double _iconSize = 17;
  static const double _titleGap = 2;

  final String icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: _tileSize,
            width: _tileSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: AppIcon(icon, size: _iconSize, color: colors.accent),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: AppTypography.label.copyWith(color: colors.ink),
                ),
                const SizedBox(height: _titleGap),
                Text(
                  body,
                  style: AppTypography.caption.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
