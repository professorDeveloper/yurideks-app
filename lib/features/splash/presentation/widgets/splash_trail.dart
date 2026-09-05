import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'flight_path.dart';

class SplashTrail extends StatelessWidget {
  const SplashTrail({
    required this.route,
    required this.head,
    required this.length,
    required this.fade,
    required this.colour,
    super.key,
  });

  final FlightPath route;
  final double head;
  final double length;
  final double fade;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrailPainter(
        route: route,
        head: head,
        length: length,
        fade: fade,
        colour: colour,
      ),
    );
  }
}

class _TrailPainter extends CustomPainter {
  const _TrailPainter({
    required this.route,
    required this.head,
    required this.length,
    required this.fade,
    required this.colour,
  });

  static const int _segments = 26;

  final FlightPath route;
  final double head;
  final double length;
  final double fade;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    if (fade <= 0.01 || head <= 0.02 || length <= 0.001) {
      return;
    }
    final double tail = (head - length).clamp(0.0, 1.0);
    if (head - tail < 0.005) {
      return;
    }

    final double step = (head - tail) / _segments;
    for (int i = 0; i < _segments; i++) {
      final double weight = i / (_segments - 1);
      final Offset from = route.pointAt(tail + step * i);
      final Offset to = route.pointAt(tail + step * (i + 1));
      final Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..strokeWidth = ui.lerpDouble(1.2, 11, weight * weight)!
        ..color = colour.withValues(alpha: 0.42 * fade * weight * weight);
      canvas.drawLine(from, to, paint);
    }
  }

  @override
  bool shouldRepaint(_TrailPainter oldDelegate) {
    return oldDelegate.head != head ||
        oldDelegate.length != length ||
        oldDelegate.fade != fade ||
        oldDelegate.colour != colour;
  }
}
