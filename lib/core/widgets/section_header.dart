import 'package:flutter/material.dart';

import '../constants/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/haptics.dart';
import 'app_icon.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.action,
    this.onAction,
    super.key,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: AppTypography.overline.copyWith(color: colors.muted),
          ),
        ),
        if (action != null && onAction != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Haptics.tap();
              onAction!.call();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.md),
              child: Row(
                children: <Widget>[
                  Text(
                    action!,
                    style: AppTypography.label.copyWith(
                      color: colors.accent,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 2),
                  AppIcon(
                    AppIcons.chevronRight,
                    size: 15,
                    color: colors.accent,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
