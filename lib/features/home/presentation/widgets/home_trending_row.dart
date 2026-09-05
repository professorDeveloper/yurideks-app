import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/app_icon.dart';

class HomeTrendingRow extends StatelessWidget {
  const HomeTrendingRow({
    required this.question,
    required this.onAsk,
    super.key,
  });

  static const double height = 132;
  static const double _tileSize = 38;

  final String question;
  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final BorderRadius shape = BorderRadius.circular(AppRadius.lg);

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
          child: InkWell(
            onTap: () {
              Haptics.tap();
              onAsk(question);
            },
            splashColor: colors.accent.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: _tileSize,
                        width: _tileSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.accentSoft,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: AppIcon(
                          AppIcons.trending,
                          size: 17,
                          color: colors.accent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          question,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyStrong.copyWith(
                            color: colors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      Text(
                        AppStrings.homeTrendingAction,
                        style: AppTypography.label.copyWith(
                          color: colors.accent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      AppIcon(
                        AppIcons.arrowUpRight,
                        size: 16,
                        color: colors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
