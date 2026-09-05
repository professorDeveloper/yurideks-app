import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class LegalConsent extends StatelessWidget {
  const LegalConsent({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final TextStyle base = AppTypography.caption.copyWith(color: colors.muted);
    final TextStyle emphasis = base.copyWith(
      color: colors.ink,
      fontWeight: FontWeight.w600,
    );

    return Text.rich(
      TextSpan(
        style: base,
        children: <InlineSpan>[
          const TextSpan(text: AppStrings.phoneLegalPrefix),
          TextSpan(text: AppStrings.phoneLegalTerms, style: emphasis),
          const TextSpan(text: AppStrings.phoneLegalMiddle),
          TextSpan(text: AppStrings.phoneLegalPrivacy, style: emphasis),
          const TextSpan(text: AppStrings.phoneLegalSuffix),
        ],
      ),
    );
  }
}
