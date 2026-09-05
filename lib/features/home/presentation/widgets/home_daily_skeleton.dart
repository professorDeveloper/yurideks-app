import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../daily_law/presentation/widgets/daily_box_card.dart';
import 'home_block_skeleton.dart';
import 'home_stat_tile.dart';

class HomeDailySkeleton extends StatelessWidget {
  const HomeDailySkeleton({required this.metricCount, super.key});

  final int metricCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const HomeBlockSkeleton(height: DailyBoxCard.height),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            for (int index = 0; index < metricCount; index++) ...<Widget>[
              if (index > 0) const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: HomeBlockSkeleton(height: HomeStatTile.height),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
