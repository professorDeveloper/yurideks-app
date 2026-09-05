import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Align(
      alignment: Alignment.centerRight,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () {
            Haptics.tap();
            onPressed();
          },
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            child: Text(
              AppStrings.loginForgot,
              style: AppTypography.caption.copyWith(
                color: colors.muted,
                decoration: TextDecoration.underline,
                decorationColor: colors.line,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
