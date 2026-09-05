import 'package:flutter/material.dart';

import '../constants/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

class TrustPanel extends StatelessWidget {
  const TrustPanel({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppIcon(AppIcons.shield, size: 16, color: colors.muted),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: AppTypography.caption.copyWith(color: colors.muted),
          ),
        ),
      ],
    );
  }
}
