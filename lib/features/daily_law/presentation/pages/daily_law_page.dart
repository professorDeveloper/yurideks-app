import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../domain/entities/daily_law.dart';
import '../bloc/daily_law_bloc.dart';
import '../widgets/daily_law_detail.dart';
import '../widgets/daily_reveal.dart';
import '../widgets/unlock_sheet.dart';

class DailyLawPage extends StatefulWidget {
  const DailyLawPage({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  State<DailyLawPage> createState() => _DailyLawPageState();
}

class _DailyLawPageState extends State<DailyLawPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2100),
  );

  @override
  void initState() {
    super.initState();
    context.read<DailyLawBloc>().add(const DailyBoxOpened());
    Haptics.success();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showUnlock() async {
    Haptics.tap();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => const UnlockSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocBuilder<DailyLawBloc, DailyLawState>(
          builder: (BuildContext context, DailyLawState state) {
            return Stack(
              children: <Widget>[
                switch (state) {
                  DailyLawError(:final String message) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.screen),
                        child: InlineNotice(message: message),
                      ),
                    ),
                  DailyLawLoaded(:final box) => DailyReveal(
                      animation: _controller,
                      child: _RevealContent(
                        law: box.law,
                        collectedCount: box.collectedCount,
                        onUnlock: _showUnlock,
                        onClose: widget.onClose,
                      ),
                    ),
                  _ => const SizedBox.shrink(),
                },
                Positioned(
                  left: AppSpacing.screen,
                  top: AppSpacing.sm,
                  child: AppBackButton(onPressed: widget.onClose),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RevealContent extends StatelessWidget {
  const _RevealContent({
    required this.law,
    required this.collectedCount,
    required this.onUnlock,
    required this.onClose,
  });

  final DailyLaw law;
  final int collectedCount;
  final Future<void> Function() onUnlock;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        60,
        AppSpacing.screen,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(child: _CollectedPill(count: collectedCount)),
                  const SizedBox(height: AppSpacing.xl),
                  DailyLawDetail(law: law),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: AppStrings.dailyUnlockMore,
            leadingIcon: AppIcons.collection,
            onPressed: onUnlock,
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(label: AppStrings.dailyClose, onPressed: onClose),
        ],
      ),
    );
  }
}

class _CollectedPill extends StatelessWidget {
  const _CollectedPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.successSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppIcon(AppIcons.success, size: 15, color: colors.success),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${AppStrings.dailyAdded} • $count',
            style: AppTypography.label.copyWith(color: colors.success),
          ),
        ],
      ),
    );
  }
}
