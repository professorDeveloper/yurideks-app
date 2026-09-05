import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.title, this.subtitle, super.key});

  final String title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: AppTypography.screenTitle.copyWith(color: colors.ink),
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          DefaultTextStyle(
            style: AppTypography.bodySmall.copyWith(color: colors.muted),
            child: subtitle!,
          ),
        ],
      ],
    );
  }
}
