import 'dart:math' as math;
import 'dart:ui';

class FlightPath {
  const FlightPath(this.start, this.controlOne, this.controlTwo, this.end);

  factory FlightPath.arrival(Offset landing, double markHeight) {
    return FlightPath(
      landing + Offset(-3.10 * markHeight, 2.55 * markHeight),
      landing + Offset(-1.45 * markHeight, 1.15 * markHeight),
      landing + Offset(-0.20 * markHeight, -0.68 * markHeight),
      landing,
    );
  }

  final Offset start;
  final Offset controlOne;
  final Offset controlTwo;
  final Offset end;

  Offset pointAt(double t) {
    final double u = 1 - t;
    final double a = u * u * u;
    final double b = 3 * u * u * t;
    final double c = 3 * u * t * t;
    final double d = t * t * t;
    return Offset(
      a * start.dx + b * controlOne.dx + c * controlTwo.dx + d * end.dx,
      a * start.dy + b * controlOne.dy + c * controlTwo.dy + d * end.dy,
    );
  }

  double headingAt(double t) {
    final double a = (t - 0.01).clamp(0.0, 1.0);
    final double b = (t + 0.01).clamp(0.0, 1.0);
    final Offset delta = pointAt(b) - pointAt(a);
    if (delta.distanceSquared < 0.0001) {
      return 0;
    }
    return math.atan2(delta.dy, delta.dx);
  }
}
