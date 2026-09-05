import 'package:flutter/widgets.dart';

abstract final class Motion {
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Cubic(0.2, 0.9, 0.2, 1);
  static const Curve spring = Cubic(0.34, 1.56, 0.64, 1);

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration scale(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}
