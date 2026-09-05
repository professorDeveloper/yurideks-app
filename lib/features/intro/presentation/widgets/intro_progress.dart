import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class IntroProgress extends StatelessWidget {
  const IntroProgress({required this.count, required this.page, super.key});

  static const double _segmentWidth = 26;
  static const double _segmentHeight = 4;

  final int count;
  final double page;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int index = 0; index < count; index++)
          Padding(
            padding: EdgeInsets.only(
              right: index == count - 1 ? 0 : AppSpacing.sm,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: SizedBox(
                width: _segmentWidth,
                height: _segmentHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ColoredBox(color: colors.line),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (page - index + 1).clamp(0.0, 1.0),
                      child: ColoredBox(color: colors.accent),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
