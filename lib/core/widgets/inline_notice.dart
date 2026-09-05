import 'package:flutter/material.dart';

import '../constants/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

enum NoticeTone { danger, success, neutral }

class InlineNotice extends StatelessWidget {
  const InlineNotice({
    required this.message,
    this.tone = NoticeTone.danger,
    this.icon,
    super.key,
  });

  final String message;
  final NoticeTone tone;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final (Color background, Color foreground) = switch (tone) {
      NoticeTone.danger => (colors.dangerSoft, colors.danger),
      NoticeTone.success => (colors.successSoft, colors.success),
      NoticeTone.neutral => (colors.surfaceMuted, colors.muted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppIcon(icon ?? _defaultIcon, size: 18, color: foreground),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTypography.caption.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }

  String get _defaultIcon => switch (tone) {
        NoticeTone.danger => AppIcons.alert,
        NoticeTone.success => AppIcons.success,
        NoticeTone.neutral => AppIcons.info,
      };
}
