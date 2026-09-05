import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/utils/uzbek_date.dart';
import 'home_avatar_button.dart';
import 'streak_badge.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    required this.now,
    required this.name,
    required this.streak,
    required this.initials,
    required this.onProfile,
    super.key,
  });

  static const double height = 64;

  final DateTime now;
  final String? name;
  final int streak;
  final String? initials;
  final VoidCallback onProfile;

  String get _greeting {
    final String greeting = Greeting.forHour(now.hour);
    final String? trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return greeting;
    }
    return '$greeting, ${trimmed.split(' ').first}';
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return SliverAppBar(
      pinned: true,
      toolbarHeight: height,
      scrolledUnderElevation: 0,
      backgroundColor: colors.background,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: AppSpacing.screen,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _greeting,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleSmall.copyWith(color: colors.ink),
          ),
          Text(
            UzbekDate.long(now),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(color: colors.muted),
          ),
        ],
      ),
      actions: <Widget>[
        if (streak > 0) StreakBadge(days: streak),
        const SizedBox(width: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.screen),
          child: HomeAvatarButton(initials: initials, onPressed: onProfile),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: colors.line),
      ),
    );
  }
}
