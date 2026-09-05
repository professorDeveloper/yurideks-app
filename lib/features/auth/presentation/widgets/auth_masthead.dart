import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/brand_wordmark.dart';

class AuthMasthead extends StatelessWidget {
  const AuthMasthead({super.key});

  static const double _wordmarkSize = 20;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const BrandWordmark(fontSize: _wordmarkSize),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.splashTagline,
          style: AppTypography.caption.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        Divider(color: colors.line, height: 1, thickness: 1),
      ],
    );
  }
}
