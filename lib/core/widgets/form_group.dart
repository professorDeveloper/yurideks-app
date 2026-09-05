import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class FormGroup extends StatelessWidget {
  const FormGroup({required this.rows, super.key});

  static const double _dividerInset = AppSpacing.lg;

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.field),
        border: Border.all(color: colors.line),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.field),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (int index = 0; index < rows.length; index++) ...<Widget>[
              if (index > 0)
                Padding(
                  padding: const EdgeInsets.only(left: _dividerInset),
                  child: Divider(color: colors.line, height: 1),
                ),
              rows[index],
            ],
          ],
        ),
      ),
    );
  }
}
