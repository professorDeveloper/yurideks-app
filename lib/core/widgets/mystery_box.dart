import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MysteryBox extends StatelessWidget {
  const MysteryBox({
    required this.size,
    this.lift = 0,
    this.bob = 0,
    this.glow = 1,
    this.reveal = 0,
    super.key,
  });

  final double size;
  final double lift;
  final double bob;
  final double glow;
  final double reveal;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        size: Size.square(size),
        painter: _MysteryBoxPainter(
          lift: lift.clamp(0.0, 1.0),
          bob: bob,
          glow: glow.clamp(0.0, 1.0),
          reveal: reveal.clamp(0.0, 1.0),
          accent: colors.accent,
          ribbon: isDark ? const Color(0xFFF6EFE4) : const Color(0xFFFFFBF5),
          shadow: isDark ? Colors.black : const Color(0xFF7A4A2E),
        ),
      ),
    );
  }
}

class _MysteryBoxPainter extends CustomPainter {
  const _MysteryBoxPainter({
    required this.lift,
    required this.bob,
    required this.glow,
    required this.reveal,
    required this.accent,
    required this.ribbon,
    required this.shadow,
  });

  static const Color _lidTopLight = Color(0xFFFFC078);
  static const Color _lidTopDeep = Color(0xFFF59A45);
  static const Color _lidSide = Color(0xFFE9782F);
  static const Color _faceRightLight = Color(0xFFEC6B33);
  static const Color _faceRightDeep = Color(0xFFD44E1F);
  static const Color _faceLeftLight = Color(0xFFC4441E);
  static const Color _faceLeftDeep = Color(0xFF9E3115);
  static const Color _cavityLight = Color(0xFF8A3218);
  static const Color _cavityDeep = Color(0xFF551A0B);

  final double lift;
  final double bob;
  final double glow;
  final double reveal;
  final Color accent;
  final Color ribbon;
  final Color shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.shortestSide;
    final double float = math.sin(bob * math.pi * 2) * 0.012 * s;

    final Offset centre = Offset(size.width / 2, size.height / 2 + float);
    final double half = s * 0.42;
    final double rise = s * 0.175;
    final double depth = s * 0.30;
    final double band = s * 0.052;
    final double open = Curves.easeOutBack.transform(lift);

    final Offset top = centre + Offset(0, -rise);
    final Offset right = centre + Offset(half, 0);
    final Offset bottom = centre + Offset(0, rise);
    final Offset left = centre + Offset(-half, 0);

    _paintCavity(canvas, <Offset>[top, right, bottom, left]);
    _paintContents(canvas, centre, s);
    _paintBody(canvas, left, right, bottom, depth, band);
    _paintLid(canvas, centre, half, rise, band, open, s);
    _paintSparkles(canvas, centre, s);
  }

  void _paintCavity(Canvas canvas, List<Offset> diamond) {
    canvas.drawPath(
      _polygon(diamond),
      Paint()
        ..isAntiAlias = true
        ..shader = ui.Gradient.linear(
          diamond[0],
          diamond[2],
          <Color>[_cavityDeep, _cavityLight],
        ),
    );
  }

  void _paintContents(Canvas canvas, Offset centre, double s) {
    if (reveal <= 0.01) {
      return;
    }
    final double rise = Curves.easeOutCubic.transform(reveal);
    final double width = s * 0.30;
    final double height = s * 0.24;
    final Offset origin = centre + Offset(0, s * 0.02 - s * 0.06 * rise);

    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..rotate(-0.09);

    final RRect sheet = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: width, height: height),
      Radius.circular(s * 0.024),
    );
    canvas
      ..drawRRect(
          sheet,
          Paint()
            ..color = ribbon
            ..isAntiAlias = true)
      ..drawRRect(
        sheet,
        Paint()
          ..color = shadow.withValues(alpha: 0.20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.007
          ..isAntiAlias = true,
      )
      ..drawCircle(
        Offset(-width * 0.24, -height * 0.24),
        s * 0.030,
        Paint()
          ..color = accent
          ..isAntiAlias = true,
      );

    final Paint rule = Paint()
      ..color = shadow.withValues(alpha: 0.24)
      ..strokeWidth = s * 0.014
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    for (int i = 0; i < 2; i++) {
      final double y = height * (0.10 + i * 0.22);
      final double end = i == 1 ? width * 0.02 : width * 0.30;
      canvas.drawLine(Offset(-width * 0.30, y), Offset(end, y), rule);
    }

    canvas.restore();
  }

  void _paintBody(
    Canvas canvas,
    Offset left,
    Offset right,
    Offset bottom,
    double depth,
    double band,
  ) {
    final Offset drop = Offset(0, depth);

    _shaded(
      canvas,
      <Offset>[left, bottom, bottom + drop, left + drop],
      left,
      bottom + drop,
      _faceLeftLight,
      _faceLeftDeep,
    );
    _shaded(
      canvas,
      <Offset>[right, bottom, bottom + drop, right + drop],
      right,
      bottom + drop,
      _faceRightLight,
      _faceRightDeep,
    );

    final Offset leftMid = Offset.lerp(left, bottom, 0.52)!;
    final Offset rightMid = Offset.lerp(right, bottom, 0.52)!;
    canvas
      ..drawLine(leftMid, leftMid + drop, _strap(band, 0.72))
      ..drawLine(rightMid, rightMid + drop, _strap(band, 0.94))
      ..drawLine(
        bottom,
        bottom + drop,
        Paint()
          ..color = shadow.withValues(alpha: 0.22)
          ..strokeWidth = band * 0.14
          ..isAntiAlias = true,
      );
  }

  Paint _strap(double band, double lightness) {
    return Paint()
      ..color = Color.lerp(shadow, ribbon, lightness)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = band
      ..isAntiAlias = true;
  }

  void _paintLid(
    Canvas canvas,
    Offset centre,
    double half,
    double rise,
    double band,
    double open,
    double s,
  ) {
    const double scale = 1.08;
    final Offset lidCentre = centre + Offset(0, -s * 0.36 * open);
    final double lidHalf = half * scale;
    final double lidRise = rise * scale;
    final double skirt = band * 1.15;

    final Offset top = lidCentre + Offset(0, -lidRise);
    final Offset right = lidCentre + Offset(lidHalf, 0);
    final Offset bottom = lidCentre + Offset(0, lidRise);
    final Offset left = lidCentre + Offset(-lidHalf, 0);
    final Offset drop = Offset(0, skirt);

    _shaded(
      canvas,
      <Offset>[left, bottom, bottom + drop, left + drop],
      left,
      bottom + drop,
      _lidSide,
      _faceLeftDeep,
    );
    _shaded(
      canvas,
      <Offset>[right, bottom, bottom + drop, right + drop],
      right,
      bottom + drop,
      _lidSide,
      _faceRightDeep,
    );
    _shaded(
      canvas,
      <Offset>[top, right, bottom, left],
      top,
      bottom,
      _lidTopLight,
      _lidTopDeep,
    );

    canvas.drawLine(
      left,
      top,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.30)
        ..strokeWidth = s * 0.008
        ..isAntiAlias = true,
    );

    canvas
      ..save()
      ..clipPath(_polygon(<Offset>[top, right, bottom, left]))
      ..drawLine(
        Offset.lerp(top, left, 0.5)!,
        Offset.lerp(right, bottom, 0.5)!,
        _strap(band, 0.88),
      )
      ..drawLine(
        Offset.lerp(top, right, 0.5)!,
        Offset.lerp(left, bottom, 0.5)!,
        _strap(band, 1),
      )
      ..restore();

    _paintBow(canvas, lidCentre, s);
  }

  void _paintBow(Canvas canvas, Offset centre, double s) {
    final double wing = s * 0.145;
    final double lobe = s * 0.09;
    final Color ribbonShade = Color.lerp(shadow, ribbon, 0.76)!;
    final Paint tailFill = Paint()
      ..color = ribbonShade
      ..isAntiAlias = true;
    final Paint edge = Paint()
      ..color = shadow.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.007
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas
      ..save()
      ..translate(centre.dx, centre.dy)
      ..scale(1, 0.56);

    for (final int side in <int>[-1, 1]) {
      final Path tail = Path()
        ..moveTo(side * wing * 0.08, lobe * 0.30)
        ..cubicTo(
          side * wing * 0.45,
          lobe * 1.00,
          side * wing * 0.78,
          lobe * 1.70,
          side * wing * 1.02,
          lobe * 2.55,
        )
        ..lineTo(side * wing * 0.74, lobe * 2.10)
        ..lineTo(side * wing * 0.60, lobe * 2.78)
        ..cubicTo(
          side * wing * 0.40,
          lobe * 1.90,
          side * wing * 0.20,
          lobe * 1.25,
          -side * wing * 0.06,
          lobe * 0.78,
        )
        ..close();
      canvas
        ..drawPath(tail, tailFill)
        ..drawPath(tail, edge);
    }

    for (final int side in <int>[-1, 1]) {
      final Path loop = Path()
        ..moveTo(0, 0)
        ..cubicTo(
          side * wing * 0.35,
          -lobe * 1.25,
          side * wing * 1.15,
          -lobe * 0.95,
          side * wing,
          0,
        )
        ..cubicTo(
          side * wing * 0.95,
          lobe * 0.95,
          side * wing * 0.30,
          lobe * 0.85,
          0,
          0,
        )
        ..close();
      final Paint loopFill = Paint()
        ..isAntiAlias = true
        ..shader = ui.Gradient.linear(
          Offset(side * wing, -lobe),
          Offset.zero,
          <Color>[ribbon, ribbonShade],
        );
      canvas
        ..drawPath(loop, loopFill)
        ..drawPath(loop, edge);
    }

    final Paint knot = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.linear(
        Offset(0, -lobe * 0.6),
        Offset(0, lobe * 0.6),
        <Color>[ribbon, Color.lerp(shadow, ribbon, 0.62)!],
      );
    canvas
      ..drawCircle(Offset.zero, lobe * 0.5, knot)
      ..drawCircle(Offset.zero, lobe * 0.5, edge)
      ..restore();
  }

  void _paintSparkles(Canvas canvas, Offset centre, double s) {
    if (glow <= 0.02) {
      return;
    }
    final Paint paint = Paint()..isAntiAlias = true;
    const List<Offset> seeds = <Offset>[
      Offset(-0.40, -0.27),
      Offset(0.37, -0.34),
      Offset(0.44, 0.06),
      Offset(-0.45, 0.03),
      Offset(0.08, -0.42),
    ];
    for (int i = 0; i < seeds.length; i++) {
      final double phase = (bob + i * 0.19) % 1;
      final double pulse = 0.45 + 0.55 * math.sin(phase * math.pi * 2).abs();
      final double radius = s * (0.024 + 0.013 * pulse);
      paint.color = accent.withValues(alpha: 0.6 * glow * pulse);
      canvas.drawPath(
        _sparkle(centre + Offset(seeds[i].dx * s, seeds[i].dy * s), radius),
        paint,
      );
    }
  }

  Path _sparkle(Offset centre, double radius) {
    final double waist = radius * 0.26;
    return Path()
      ..moveTo(centre.dx, centre.dy - radius)
      ..quadraticBezierTo(
        centre.dx + waist,
        centre.dy - waist,
        centre.dx + radius,
        centre.dy,
      )
      ..quadraticBezierTo(
        centre.dx + waist,
        centre.dy + waist,
        centre.dx,
        centre.dy + radius,
      )
      ..quadraticBezierTo(
        centre.dx - waist,
        centre.dy + waist,
        centre.dx - radius,
        centre.dy,
      )
      ..quadraticBezierTo(
        centre.dx - waist,
        centre.dy - waist,
        centre.dx,
        centre.dy - radius,
      )
      ..close();
  }

  void _shaded(
    Canvas canvas,
    List<Offset> points,
    Offset from,
    Offset to,
    Color start,
    Color end,
  ) {
    canvas.drawPath(
      _polygon(points),
      Paint()
        ..isAntiAlias = true
        ..shader = ui.Gradient.linear(from, to, <Color>[start, end]),
    );
  }

  Path _polygon(List<Offset> points) {
    final Path path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final Offset point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(_MysteryBoxPainter oldDelegate) {
    return oldDelegate.lift != lift ||
        oldDelegate.bob != bob ||
        oldDelegate.glow != glow ||
        oldDelegate.reveal != reveal ||
        oldDelegate.accent != accent ||
        oldDelegate.ribbon != ribbon;
  }
}
