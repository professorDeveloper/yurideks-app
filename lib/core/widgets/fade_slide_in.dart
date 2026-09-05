import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../utils/motion.dart';

class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.offset = 18,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final double offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDuration.slow,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (mounted) {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduced(context)) {
      return widget.child;
    }

    final Animation<double> curved = CurvedAnimation(
      parent: _controller,
      curve: Motion.enter,
    );

    return AnimatedBuilder(
      animation: curved,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: curved.value,
          child: Transform.translate(
            offset: Offset(0, widget.offset * (1 - curved.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
