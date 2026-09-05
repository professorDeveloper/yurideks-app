import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/motion.dart';

class SplashLoader extends StatefulWidget {
  const SplashLoader({super.key});

  static const Duration _appearsAfter = Duration(milliseconds: 3100);

  @override
  State<SplashLoader> createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<SplashLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  Timer? _timer;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(SplashLoader._appearsAfter, () {
      if (mounted) {
        setState(() => _isVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return AnimatedOpacity(
      opacity: _isVisible ? 1 : 0,
      duration: AppDuration.slow,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final bool reduced = Motion.reduced(context);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int index = 0; index < 3; index++)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs - 1,
                  ),
                  child: Opacity(
                    opacity: reduced
                        ? 0.5
                        : 0.25 +
                            0.55 *
                                (0.5 +
                                    0.5 *
                                        math.sin(
                                          (_controller.value - index * 0.18) *
                                              math.pi *
                                              2,
                                        )),
                    child: Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                        color: colors.muted,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
