import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/motion.dart';
import '../../../../core/widgets/mystery_box.dart';
import 'daily_burst.dart';

class DailyReveal extends StatelessWidget {
  const DailyReveal({
    required this.animation,
    required this.child,
    super.key,
  });

  static const double _shakeEnd = 0.16;
  static const double _liftStart = 0.14;
  static const double _liftEnd = 0.42;
  static const double _revealStart = 0.30;
  static const double _revealEnd = 0.56;
  static const double _fadeStart = 0.46;
  static const double _fadeEnd = 0.66;
  static const double _contentStart = 0.54;

  final Animation<double> animation;
  final Widget child;

  static double _span(double value, double from, double to) =>
      ((value - from) / (to - from)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final bool reduced = Motion.reduced(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? body) {
        final double raw = reduced ? 1 : animation.value;
        final double shake = raw < _shakeEnd
            ? math.sin(raw / _shakeEnd * math.pi * 6) * 0.045
            : 0;
        final double lift = _span(raw, _liftStart, _liftEnd);
        final double reveal = _span(raw, _revealStart, _revealEnd);
        final double boxFade = 1 - _span(raw, _fadeStart, _fadeEnd);
        final double content = Curves.easeOutCubic.transform(
          _span(raw, _contentStart, 1),
        );
        final double burst = _span(raw, 0.18, 0.78);

        return Stack(
          children: <Widget>[
            if (boxFade > 0.01)
              Align(
                alignment: const Alignment(0, -0.32),
                child: Opacity(
                  opacity: boxFade,
                  child: Transform.rotate(
                    angle: shake,
                    child: MysteryBox(
                      size: 240,
                      lift: lift,
                      bob: 0.25,
                      reveal: reveal,
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: DailyBurst(progress: burst, colour: colors.accent),
              ),
            ),
            Opacity(
              opacity: content,
              child: Transform.translate(
                offset: Offset(0, 40 * (1 - content)),
                child: body,
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }
}
