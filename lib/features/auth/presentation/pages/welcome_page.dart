import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_label.dart';
import '../../domain/entities/auth_user.dart';
import '../widgets/account_summary.dart';
import '../widgets/success_mark.dart';
import '../widgets/welcome_next_steps.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({required this.user, required this.onContinue, super.key});

  final AuthUser user;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.xxl,
                AppSpacing.screen,
                AppSpacing.xl,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight - AppSpacing.xxl - AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const _WelcomeHeader(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xxl,
                      ),
                      child: _WelcomeDetails(user: user),
                    ),
                    PrimaryButton(
                      label: AppStrings.welcomeAction,
                      trailingIcon: AppIcons.arrowRight,
                      onPressed: onContinue,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return FadeSlideIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SuccessMark(),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SectionLabel(text: AppStrings.welcomeBadge, accented: true),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppStrings.welcomeTitle,
                      style: AppTypography.screenTitle.copyWith(
                        color: colors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.welcomeSubtitle,
            style: AppTypography.bodySmall.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}

class _WelcomeDetails extends StatelessWidget {
  const _WelcomeDetails({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AccountSummary(user: user),
        const SizedBox(height: AppSpacing.xxl),
        SectionLabel(text: AppStrings.welcomeNextTitle),
        const SizedBox(height: AppSpacing.sm),
        const WelcomeNextSteps(),
      ],
    );
  }
}
