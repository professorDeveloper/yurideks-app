import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

class CountdownText extends StatefulWidget {
  const CountdownText({required this.target, this.style, super.key});

  final DateTime target;
  final TextStyle? style;

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  Timer? _timer;
  late Duration _remaining = _measure();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() => _remaining = _measure());
    });
  }

  @override
  void didUpdateWidget(CountdownText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _remaining = _measure();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration _measure() {
    final Duration left = widget.target.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  String get _formatted {
    final int hours = _remaining.inHours;
    final int minutes = _remaining.inMinutes.remainder(60);
    final int seconds = _remaining.inSeconds.remainder(60);
    final String mm = minutes.toString().padLeft(2, '0');
    final String ss = seconds.toString().padLeft(2, '0');
    return '${hours.toString().padLeft(2, '0')}:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Text(_formatted, style: widget.style ?? AppTypography.numeric);
  }
}
