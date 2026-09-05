import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({this.fontSize = 24, this.showMark = true, super.key});

  final double fontSize;
  final bool showMark;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: AppStrings.brand,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showMark) ...<Widget>[
            Image.asset(
              isDark ? AppAssets.birdMarkLight : AppAssets.birdMark,
              height: fontSize * 1.15,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: AppStrings.brandHead,
                  style: TextStyle(color: colors.ink),
                ),
                TextSpan(
                  text: AppStrings.brandTail,
                  style: TextStyle(color: colors.accent),
                ),
              ],
            ),
            style: AppTypography.headline.copyWith(
              fontSize: fontSize,
              letterSpacing: -fontSize * 0.03,
            ),
          ),
        ],
      ),
    );
  }
}
