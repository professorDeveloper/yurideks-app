import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/app_icon.dart';

class HomeStatTile extends StatelessWidget {
  const HomeStatTile({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
    this.onTap,
    super.key,
  });

  static const double height = 126;
  static const double _tileSize = 34;
  static const double _iconSize = 17;

  final String icon;
  final String label;
  final String? value;
  final Widget? valueWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final BorderRadius shape = BorderRadius.circular(AppRadius.lg);

    final Widget body = Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: _tileSize,
                width: _tileSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: AppIcon(icon, size: _iconSize, color: colors.accent),
              ),
              const Spacer(),
              if (onTap != null)
                AppIcon(
                  AppIcons.chevronRight,
                  size: 17,
                  color: colors.muted,
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: valueWidget ??
                    Text(
                      value ?? '',
                      maxLines: 1,
                      style: AppTypography.headline.copyWith(color: colors.ink),
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(color: colors.muted),
              ),
            ],
          ),
        ],
      ),
    );

    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: shape,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.overlay,
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: colors.surface,
          borderRadius: shape,
          clipBehavior: Clip.antiAlias,
          child: onTap == null
              ? body
              : InkWell(
                  onTap: () {
                    Haptics.tap();
                    onTap!.call();
                  },
                  splashColor: colors.accent.withValues(alpha: 0.06),
                  child: body,
                ),
        ),
      ),
    );
  }
}
