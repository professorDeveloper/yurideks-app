import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/initials.dart';
import '../../../../core/widgets/bird_mark.dart';

class ProfileIdentity extends StatelessWidget {
  const ProfileIdentity({required this.name, required this.phone, super.key});

  final String? name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final String? initials = Initials.of(name);

    return Column(
      children: <Widget>[
        Container(
          height: 84,
          width: 84,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.accentSoft,
            shape: BoxShape.circle,
            border: Border.all(color: colors.line),
          ),
          child: initials == null
              ? const BirdMark(height: 38)
              : Text(
                  initials,
                  style: AppTypography.headline.copyWith(
                    color: colors.accent,
                    fontSize: 28,
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          name?.trim().isNotEmpty ?? false ? name!.trim() : phone,
          textAlign: TextAlign.center,
          style: AppTypography.screenTitle.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            AppStrings.profileCitizen,
            style: AppTypography.caption.copyWith(color: colors.muted),
          ),
        ),
      ],
    );
  }
}
