import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/haptics.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.radius = AppRadius.lg,
    this.background,
    this.borderColor,
    this.elevated = true,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final double radius;
  final Color? background;
  final Color? borderColor;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final BorderRadius shape = BorderRadius.circular(radius);
    final Widget body = Padding(padding: padding, child: child);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: elevated
            ? <BoxShadow>[
                BoxShadow(
                  color: colors.overlay,
                  blurRadius: 22,
                  offset: const Offset(0, 6),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Material(
        color: background ?? colors.surface,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: onTap == null
            ? _bordered(shape, colors, body)
            : InkWell(
                onTap: () {
                  Haptics.tap();
                  onTap!.call();
                },
                splashColor: colors.ink.withValues(alpha: 0.05),
                highlightColor: colors.ink.withValues(alpha: 0.035),
                child: _bordered(shape, colors, body),
              ),
      ),
    );
  }

  Widget _bordered(BorderRadius shape, AppColors colors, Widget body) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        border: Border.all(color: borderColor ?? colors.line),
      ),
      child: body,
    );
  }
}
