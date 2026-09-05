import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class HomeBlockSkeleton extends StatelessWidget {
  const HomeBlockSkeleton({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    );
  }
}
