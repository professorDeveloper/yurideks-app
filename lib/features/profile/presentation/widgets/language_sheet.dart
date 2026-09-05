import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../domain/entities/app_settings.dart';

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({required this.selected, super.key});

  final AppLocale selected;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.md,
        AppSpacing.screen,
        AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              height: 4,
              width: 44,
              decoration: BoxDecoration(
                color: colors.line,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppStrings.profileLanguage,
            style: AppTypography.titleSmall.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.md),
          for (int index = 0; index < AppLocale.values.length; index++)
            InkWell(
              onTap: () {
                Haptics.tap();
                Navigator.of(context).pop(AppLocale.values[index]);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        AppStrings.languages[index],
                        style: AppTypography.bodyStrong.copyWith(
                          color: colors.ink,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (AppLocale.values[index] == selected)
                      AppIcon(
                        AppIcons.check,
                        size: 19,
                        color: colors.accent,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
