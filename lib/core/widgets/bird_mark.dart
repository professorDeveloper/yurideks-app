import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/bird_geometry.dart';

class BirdMark extends StatelessWidget {
  const BirdMark({
    required this.height,
    this.wingAngle = 0,
    this.tailAngle = 0,
    this.opacity = 1,
    this.monochrome,
    super.key,
  });

  final double height;
  final double wingAngle;
  final double tailAngle;
  final double opacity;
  final Color? monochrome;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color ink =
        monochrome ?? (isDark ? colors.ink : const Color(0xFF121212));

    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: SizedBox(
        height: height,
        width: height * BirdGeometry.aspectRatio,
        child: CustomPaint(
          painter: _BirdPainter(
            wingAngle: wingAngle,
            tailAngle: tailAngle,
            ink: ink,
            plumage: monochrome == null
                ? <Color>[
                    isDark ? const Color(0xFFFFA24D) : const Color(0xFFF2993D),
                    colors.accent,
                    isDark ? const Color(0xFFE84B22) : const Color(0xFFD5391F),
                  ]
                : <Color>[monochrome!, monochrome!, monochrome!],
          ),
        ),
      ),
    );
  }
}

class _BirdPainter extends CustomPainter {
  const _BirdPainter({
    required this.wingAngle,
    required this.tailAngle,
    required this.ink,
    required this.plumage,
  });

  final double wingAngle;
  final double tailAngle;
  final Color ink;
  final List<Color> plumage;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint inkPaint = Paint()
      ..isAntiAlias = true
      ..color = ink;

    final Rect bounds = Offset.zero & size;
    final Paint bodyPaint = Paint()
      ..isAntiAlias = true
      ..shader = LinearGradient(
        begin: const Alignment(0.35, -1),
        end: const Alignment(-0.55, 1),
        colors: plumage,
        stops: const <double>[0, 0.52, 1],
      ).createShader(bounds);

    _drawPivoted(
      canvas,
      size,
      BirdGeometry.tail(size),
      inkPaint,
      tailAngle,
      BirdGeometry.tailPivot,
    );
    _drawPivoted(
      canvas,
      size,
      BirdGeometry.wing(size),
      inkPaint,
      wingAngle,
      BirdGeometry.wingPivot,
    );

    canvas.drawPath(BirdGeometry.body(size), bodyPaint);
  }

  void _drawPivoted(
    Canvas canvas,
    Size size,
    Path path,
    Paint paint,
    double angle,
    Offset pivot,
  ) {
    if (angle.abs() < 0.0005) {
      canvas.drawPath(path, paint);
      return;
    }
    final double px = pivot.dx * size.width;
    final double py = pivot.dy * size.height;
    canvas
      ..save()
      ..translate(px, py)
      ..transform(
        Matrix4.identity()
            .scaledByDouble(1, math.cos(angle * 0.42).clamp(0.7, 1.0), 1, 1)
            .storage,
      )
      ..rotate(angle)
      ..translate(-px, -py)
      ..drawPath(path, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(_BirdPainter oldDelegate) {
    return oldDelegate.wingAngle != wingAngle ||
        oldDelegate.tailAngle != tailAngle ||
        oldDelegate.ink != ink ||
        oldDelegate.plumage != plumage;
  }
}
