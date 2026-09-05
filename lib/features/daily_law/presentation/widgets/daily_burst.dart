import 'dart:math' as math;

import 'package:flutter/material.dart';

class DailyBurst extends StatelessWidget {
  const DailyBurst({required this.progress, required this.colour, super.key});

  final double progress;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BurstPainter(progress: progress, colour: colour),
    );
  }
}

class _BurstPainter extends CustomPainter {
  const _BurstPainter({required this.progress, required this.colour});

  static const int _count = 22;

  final double progress;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) {
      return;
    }
    final Offset origin = Offset(size.width / 2, size.height * 0.46);
    final double reach = size.shortestSide * 0.62;
    final double eased = Curves.easeOutCubic.transform(progress);
    final double fade = 1 - Curves.easeInCubic.transform(progress);
    final Paint paint = Paint()..isAntiAlias = true;

    for (int i = 0; i < _count; i++) {
      final double seed = i / _count;
      final double angle = seed * math.pi * 2 + (i.isEven ? 0.22 : -0.15);
      final double speed = 0.55 + (i % 5) * 0.11;
      final double distance = reach * eased * speed;
      final double gravity = size.height * 0.30 * eased * eased * speed;
      final Offset at = origin +
          Offset(
              math.cos(angle) * distance, math.sin(angle) * distance + gravity);
      final double radius =
          size.shortestSide * (0.014 + (i % 4) * 0.004) * fade;
      paint.color = (i % 3 == 0 ? Colors.white : colour).withValues(
        alpha: 0.85 * fade,
      );
      canvas.save();
      canvas.translate(at.dx, at.dy);
      canvas.rotate(angle + eased * 3.4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: radius * 2.4,
            height: radius * 1.1,
          ),
          Radius.circular(radius),
        ),
        paint,
      );
      canvas.restore();
    }

    final double ringEase = Curves.easeOutCubic.transform(
      (progress / 0.55).clamp(0.0, 1.0),
    );
    if (ringEase < 1) {
      canvas.drawCircle(
        origin,
        reach * 0.9 * ringEase,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4 * (1 - ringEase)
          ..color = colour.withValues(alpha: 0.45 * (1 - ringEase)),
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.colour != colour;
}
