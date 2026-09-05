import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/citation.dart';
import 'escalation_card.dart';

class AnswerBody extends StatelessWidget {
  const AnswerBody({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 330),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message.content,
                  style: AppTypography.bodySmall.copyWith(color: colors.ink),
                ),
                if (message.steps.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppStrings.dailyStepsTitle,
                    style: AppTypography.label.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (int index = 0; index < message.steps.length; index++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        '${index + 1}. ${message.steps[index]}',
                        style: AppTypography.caption.copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ),
                ],
                if (message.citations.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: <Widget>[
                      for (final Citation citation in message.citations)
                        _CitationPill(citation: citation),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (message.needsEscalation) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            const EscalationCard(),
          ],
        ],
      ),
    );
  }
}

class _CitationPill extends StatelessWidget {
  const _CitationPill({required this.citation});

  final Citation citation;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppIcon(AppIcons.law, size: 13, color: colors.accent),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            '${citation.source} • ${citation.article}',
            style: AppTypography.overline.copyWith(
              color: colors.accent,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
