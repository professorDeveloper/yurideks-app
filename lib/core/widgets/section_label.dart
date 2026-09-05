import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(
      {required this.text, this.accented = false, this.trailing, super.key});

  final String text;
  final bool accented;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            text.toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: accented ? colors.accent : colors.muted,
            ),
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: AppSpacing.md),
          trailing!,
        ],
      ],
    );
  }
}
