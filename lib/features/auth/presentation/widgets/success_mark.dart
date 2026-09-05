import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/motion.dart';
import '../../../../core/widgets/app_icon.dart';

class SuccessMark extends StatefulWidget {
  const SuccessMark({this.size = 44, super.key});

  static const Duration entryDuration = Duration(milliseconds: 420);
  static const double iconRatio = 0.5;

  final double size;

  @override
  State<SuccessMark> createState() => _SuccessMarkState();
}

class _SuccessMarkState extends State<SuccessMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entry = AnimationController(
    vsync: this,
    duration: SuccessMark.entryDuration,
  )..forward();

  @override
  void dispose() {
    _entry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Widget mark = Container(
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
      child: AppIcon(
        AppIcons.check,
        size: widget.size * SuccessMark.iconRatio,
        color: colors.accentInk,
      ),
    );

    if (Motion.reduced(context)) {
      return mark;
    }
    return ScaleTransition(
      scale: CurvedAnimation(parent: _entry, curve: Motion.spring),
      child: mark,
    );
  }
}
