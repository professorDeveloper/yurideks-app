import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/mystery_box.dart';
import '../../domain/entities/daily_law.dart';

class CollectionTile extends StatelessWidget {
  const CollectionTile({required this.law, this.onTap, super.key});

  final DailyLaw? law;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final DailyLaw? entry = law;

    if (entry == null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.line),
        ),
        child: Center(
          child: Opacity(
            opacity: 0.28,
            child: MysteryBox(size: 78, glow: 0),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              Haptics.tap();
              onTap!();
            },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 2,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: colors.accentSoft,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                entry.topic,
                style: AppTypography.overline.copyWith(
                  color: colors.accent,
                  fontSize: 9.5,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: Text(
                entry.title,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label.copyWith(color: colors.ink),
              ),
            ),
            Text(
              entry.article,
              style: AppTypography.caption.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
