import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/app_icon.dart';

class HomeAvatarButton extends StatelessWidget {
  const HomeAvatarButton({
    required this.initials,
    required this.onPressed,
    super.key,
  });

  static const double _diameter = 38;
  static const double _initialsSize = 13;

  final String? initials;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final String? letters = initials;

    return Material(
      color: colors.accentSoft,
      shape: CircleBorder(side: BorderSide(color: colors.line)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Haptics.tap();
          onPressed();
        },
        splashColor: colors.accent.withValues(alpha: 0.12),
        child: SizedBox.square(
          dimension: _diameter,
          child: Center(
            child: letters == null
                ? AppIcon(AppIcons.profile, size: 18, color: colors.accent)
                : Text(
                    letters,
                    style: AppTypography.label.copyWith(
                      color: colors.accent,
                      fontSize: _initialsSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
