import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/phone_number.dart';

class DialCode extends StatelessWidget {
  const DialCode({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Text(
      PhoneNumber.dialCode,
      style: AppTypography.input.copyWith(color: colors.muted),
    );
  }
}
