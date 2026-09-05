import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_icon.dart';

class PasswordRule extends StatelessWidget {
  const PasswordRule({
    required this.label,
    required this.isSatisfied,
    super.key,
  });

  static const double _iconSize = 15;
  static const double _dotSize = 5;
  static const double _iconTopInset = 2;

  final String label;
  final bool isSatisfied;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color tint = isSatisfied ? colors.success : colors.muted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: _iconTopInset),
          child: isSatisfied
              ? AppIcon(AppIcons.check, size: _iconSize, color: tint)
              : Padding(
                  padding: const EdgeInsets.all(
                    (_iconSize - _dotSize) / 2,
                  ),
                  child: Container(
                    height: _dotSize,
                    width: _dotSize,
                    decoration: BoxDecoration(
                      color: tint,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: AppTypography.caption.copyWith(color: tint),
          ),
        ),
      ],
    );
  }
}
