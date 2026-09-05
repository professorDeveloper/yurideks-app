import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/bird_geometry.dart';
import '../../../../core/utils/motion.dart';
import '../../../../core/widgets/bird_mark.dart';
import 'flight_path.dart';
import 'splash_loader.dart';
import 'splash_trail.dart';
import 'splash_wordmark.dart';

class SplashStage extends StatelessWidget {
  const SplashStage({required this.animation, super.key});

  static const double _markHeight = 104;
  static const double _flightStart = 0.04;
  static const double _flightEnd = 0.58;
  static const double _trailGone = 0.74;
  static const double _glowStart = 0.48;
  static const double _glowEnd = 0.78;
  static const double _wordmarkStart = 0.58;
  static const double _wordmarkEnd = 0.86;
  static const double _taglineStart = 0.78;

  final Animation<double> animation;

  static double _span(double value, double from, double to) =>
      ((value - from) / (to - from)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final bool reduced = Motion.reduced(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size stage = Size(constraints.maxWidth, constraints.maxHeight);
        final Offset landing = Offset(stage.width * 0.5, stage.height * 0.40);
        final FlightPath route = FlightPath.arrival(landing, _markHeight);

        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            final double raw = reduced ? 1 : animation.value;
            final double t = _span(raw, _flightStart, _flightEnd);
            final double eased = Curves.easeOutCubic.transform(t);
            final double back = Curves.easeOutBack.transform(t);
            final double settle = _span(raw, _flightEnd, 1);

            final Offset position = t >= 1 ? landing : route.pointAt(eased);
            final double scale = ui.lerpDouble(0.30, 1, back)!;
            final double rotation = -0.38 * (1 - back);
            final double wing = t < 1
                ? math.sin(t * math.pi * 2 * 3.2) *
                    0.40 *
                    math.pow(1 - t, 0.7).toDouble()
                : math.sin(settle * math.pi * 2 * 1.5) * 0.08 * (1 - settle);
            final double glow = _span(raw, _glowStart, _glowEnd);
            final double reveal = Curves.easeOutCubic.transform(
              _span(raw, _wordmarkStart, _wordmarkEnd),
            );
            final double tagline = Curves.easeOutCubic.transform(
              _span(raw, _taglineStart, 1),
            );

            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned.fill(
                  child: SplashTrail(
                    route: route,
                    head: (eased - 0.02).clamp(0.0, 1.0),
                    length: ui.lerpDouble(0.10, 0.36, t)!,
                    fade: 1 - _span(raw, _flightEnd - 0.06, _trailGone),
                    colour: colors.accent,
                  ),
                ),
                _at(
                  landing,
                  Size(stage.width * 0.82, stage.width * 0.82),
                  Opacity(
                    opacity: Curves.easeOutCubic.transform(glow) * 0.95,
                    child: _Bloom(
                      size: stage.width * 0.82,
                      colour: colors.accent,
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.06),
                  child: SplashWordmark(progress: reveal),
                ),
                Align(
                  alignment: const Alignment(0, 0.21),
                  child: Opacity(
                    opacity: tagline,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - tagline)),
                      child: Text(
                        AppStrings.splashTagline,
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ),
                  ),
                ),
                _at(
                  position,
                  Size(
                    _markHeight * BirdGeometry.aspectRatio * scale,
                    _markHeight * scale,
                  ),
                  Transform.rotate(
                    angle: rotation,
                    child: Transform.scale(
                      scale: scale,
                      child: BirdMark(
                        height: _markHeight,
                        wingAngle: wing,
                        tailAngle: wing * -0.26,
                        opacity: Curves.easeOut.transform(
                          (t / 0.10).clamp(0.0, 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment(0, 0.88),
                  child: SplashLoader(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _at(Offset centre, Size box, Widget child) {
    return Positioned(
      left: centre.dx - box.width / 2,
      top: centre.dy - box.height / 2,
      width: box.width,
      height: box.height,
      child: Center(child: child),
    );
  }
}

class _Bloom extends StatelessWidget {
  const _Bloom({required this.size, required this.colour});

  final double size;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              colour.withValues(alpha: isDark ? 0.22 : 0.13),
              colour.withValues(alpha: 0),
            ],
            stops: const <double>[0, 0.55],
          ),
        ),
      ),
    );
  }
}
