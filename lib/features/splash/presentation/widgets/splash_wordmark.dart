import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_wordmark.dart';

class SplashWordmark extends StatelessWidget {
  const SplashWordmark({required this.progress, this.fontSize = 40, super.key});

  final double progress;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Widget wordmark = BrandWordmark(fontSize: fontSize, showMark: false);

    if (progress >= 0.999) {
      return wordmark;
    }
    if (progress <= 0.001) {
      return Opacity(opacity: 0, child: wordmark);
    }

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (Rect bounds) {
        final double edge = progress * 1.22;
        return LinearGradient(
          colors: <Color>[
            colors.ink,
            colors.ink,
            colors.ink.withValues(alpha: 0),
            colors.ink.withValues(alpha: 0),
          ],
          stops: <double>[
            0,
            (edge - 0.22).clamp(0.0, 1.0),
            edge.clamp(0.0, 1.0),
            1,
          ],
        ).createShader(bounds);
      },
      child: wordmark,
    );
  }
}
