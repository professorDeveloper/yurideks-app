import 'package:flutter/material.dart';

import '../constants/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/haptics.dart';
import 'app_icon.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({required this.onPressed, this.semanticLabel, super.key});

  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Semantics(
      button: true,
      label:
          semanticLabel ?? MaterialLocalizations.of(context).backButtonTooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Haptics.tap();
            onPressed();
          },
          splashColor: colors.ink.withValues(alpha: 0.06),
          highlightColor: colors.ink.withValues(alpha: 0.04),
          child: SizedBox(
            height: 44,
            width: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppIcon(AppIcons.arrowLeft, size: 22, color: colors.ink),
            ),
          ),
        ),
      ),
    );
  }
}
