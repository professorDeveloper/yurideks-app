import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/haptics.dart';
import 'app_icon.dart';

class ChoiceChipTile extends StatelessWidget {
  const ChoiceChipTile({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color background = isSelected ? colors.accent : colors.surface;
    final Color foreground = isSelected ? colors.accentInk : colors.ink;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: () {
          Haptics.tap();
          onPressed();
        },
        child: AnimatedContainer(
          duration: AppDuration.fast,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: isSelected ? colors.accent : colors.line,
              width: 1.3,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                AppIcon(icon!, size: 16, color: foreground),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: AppTypography.label.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
