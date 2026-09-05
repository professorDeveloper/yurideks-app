import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/form_group.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/phone_number.dart';

class AccountSummary extends StatelessWidget {
  const AccountSummary({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return FormGroup(
      rows: <Widget>[
        _SummaryRow(label: AppStrings.profileName, value: user.name),
        _SummaryRow(
          label: AppStrings.profilePhone,
          value: PhoneNumber.fromE164(user.phone).formatted,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: AppTypography.caption.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.bodyStrong.copyWith(color: colors.ink),
          ),
        ],
      ),
    );
  }
}
