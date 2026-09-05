import 'package:flutter/material.dart';

import '../constants/app_icons.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/haptics.dart';
import 'app_icon.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentIndex,
    required this.onSelected,
    super.key,
  });

  static const List<({String icon, String label})> _items =
      <({String icon, String label})>[
    (icon: AppIcons.home, label: AppStrings.navHome),
    (icon: AppIcons.chat, label: AppStrings.navChat),
    (icon: AppIcons.collection, label: AppStrings.navCollection),
    (icon: AppIcons.profile, label: AppStrings.navProfile),
  ];

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: <Widget>[
              for (int index = 0; index < _items.length; index++)
                Expanded(
                  child: _NavTab(
                    icon: _items[index].icon,
                    label: _items[index].label,
                    isActive: index == currentIndex,
                    onPressed: () {
                      Haptics.tap();
                      onSelected(index);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  static const double height = 48;
  static const double _indicatorHeight = 28;
  static const double _indicatorWidth = 52;
  static const double _labelSize = 11;

  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color tint = isActive ? colors.accent : colors.muted;

    return Semantics(
      button: true,
      selected: isActive,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.field),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashColor: colors.accent.withValues(alpha: 0.10),
          highlightColor: colors.accent.withValues(alpha: 0.06),
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: AppDuration.fast,
                  curve: Curves.easeOut,
                  height: _indicatorHeight,
                  width: _indicatorWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? colors.accentSoft : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: AppIcon(icon, size: 21, color: tint),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.overline.copyWith(
                    color: tint,
                    fontSize: _labelSize,
                    letterSpacing: 0.1,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
