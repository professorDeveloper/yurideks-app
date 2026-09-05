import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/bird_mark.dart';

class HomeAskHero extends StatelessWidget {
  const HomeAskHero({required this.onAsk, super.key});

  static const double _watermarkHeight = 104;
  static const double _watermarkRight = AppSpacing.xl;
  static const double _watermarkBottom = AppSpacing.lg;
  static const double _watermarkOpacity = 0.16;
  static const double _ctaHeight = 46;

  final VoidCallback onAsk;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final BorderRadius shape = BorderRadius.circular(AppRadius.xl);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        color: colors.accent,
        child: InkWell(
          onTap: () {
            Haptics.tap();
            onAsk();
          },
          splashColor: colors.accentInk.withValues(alpha: 0.08),
          highlightColor: colors.accentInk.withValues(alpha: 0.05),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[colors.accent, colors.accentDeep],
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: _watermarkRight,
                  bottom: _watermarkBottom,
                  child: Opacity(
                    opacity: _watermarkOpacity,
                    child: BirdMark(
                      height: _watermarkHeight,
                      monochrome: colors.accentInk,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppStrings.homeAskLead,
                        style: AppTypography.overline.copyWith(
                          color: colors.accentInk.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppStrings.homeAskHeadline,
                        style: AppTypography.title.copyWith(
                          color: colors.accentInk,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _AskCta(label: AppStrings.homeAskTitle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AskCta extends StatelessWidget {
  const _AskCta({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      height: HomeAskHero._ctaHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.accentInk,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(label,
              style: AppTypography.button.copyWith(color: colors.accent)),
          const SizedBox(width: AppSpacing.sm),
          AppIcon(AppIcons.arrowUpRight, size: 17, color: colors.accent),
        ],
      ),
    );
  }
}
