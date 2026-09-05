import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/intro_slide.dart';
import 'intro_art.dart';

class IntroSlideView extends StatelessWidget {
  const IntroSlideView({required this.slide, required this.offset, super.key});

  static const double _maxArtSide = 300;
  static const double _artHeightRatio = 0.44;
  static const double _maxTextWidth = 320;
  static const double _textParallax = 18;
  static const double _fadeRate = 1.4;

  final IntroSlide slide;
  final double offset;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final double distance = offset.abs().clamp(0.0, 1.0);
    final double fade = (1 - distance * _fadeRate).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double side = math.min(
          _maxArtSide,
          math.min(
            constraints.maxWidth,
            constraints.maxHeight * _artHeightRatio,
          ),
        );
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox.square(
                dimension: side,
                child: IntroArt(asset: slide.illustration, offset: offset),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Opacity(
                opacity: fade,
                child: Transform.translate(
                  offset: Offset(-offset * _textParallax, 0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxTextWidth),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          slide.overline.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: AppTypography.overline.copyWith(
                            color: colors.accent,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.screenTitle.copyWith(
                            color: colors.ink,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          slide.body,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
