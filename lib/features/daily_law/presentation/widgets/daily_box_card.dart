import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/utils/motion.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/mystery_box.dart';
import '../../domain/entities/daily_box.dart';

class DailyBoxCard extends StatefulWidget {
  const DailyBoxCard({required this.box, required this.onOpen, super.key});

  static const double height = 104;

  final DailyBox box;
  final VoidCallback onOpen;

  @override
  State<DailyBoxCard> createState() => _DailyBoxCardState();
}

class _DailyBoxCardState extends State<DailyBoxCard>
    with SingleTickerProviderStateMixin {
  static const Duration _bobCycle = Duration(milliseconds: 3000);

  AnimationController? _bob;

  @override
  void initState() {
    super.initState();
    _syncBob();
  }

  @override
  void didUpdateWidget(DailyBoxCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.box.isOpened != widget.box.isOpened) {
      _syncBob();
    }
  }

  @override
  void dispose() {
    _bob?.dispose();
    super.dispose();
  }

  void _syncBob() {
    if (widget.box.isOpened) {
      _bob?.dispose();
      _bob = null;
      return;
    }
    _bob ??= AnimationController(vsync: this, duration: _bobCycle)..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AnimationController? bob = _bob;

    final bool isClosed = bob != null;

    final BorderRadius shape = BorderRadius.circular(AppRadius.xl);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: isClosed
                ? colors.accent.withValues(alpha: 0.16)
                : colors.overlay,
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: isClosed ? Colors.transparent : colors.surface,
        borderRadius: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Haptics.tap();
            widget.onOpen();
          },
          splashColor: colors.accent.withValues(alpha: 0.08),
          highlightColor: colors.accent.withValues(alpha: 0.05),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: isClosed ? colors.accentSoft : colors.line,
              ),
              color: isClosed ? null : colors.surface,
              gradient: isClosed
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[colors.accentSoft, colors.surface],
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: isClosed
                  ? _ClosedHero(bob: bob)
                  : _OpenedCard(box: widget.box),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClosedHero extends StatelessWidget {
  const _ClosedHero({required this.bob});

  static const double _boxSize = 152;

  final AnimationController bob;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final bool reduced = Motion.reduced(context);

    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: bob,
          builder: (BuildContext context, Widget? child) => MysteryBox(
            size: _boxSize,
            bob: reduced ? 0.25 : bob.value,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.dailyReady,
          textAlign: TextAlign.center,
          style: AppTypography.titleSmall.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppIcon(AppIcons.pointer, size: 14, color: colors.accent),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              AppStrings.dailyOpenHint,
              style: AppTypography.caption.copyWith(color: colors.accent),
            ),
          ],
        ),
      ],
    );
  }
}

class _OpenedCard extends StatelessWidget {
  const _OpenedCard({required this.box});

  static const double _thumbSize = 52;

  final DailyBox box;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox.square(
              dimension: _thumbSize,
              child: MysteryBox(size: _thumbSize, lift: 1, reveal: 1),
            ),
            const SizedBox(width: AppSpacing.md),
            const _OpenedBadge(),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          box.law.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.titleSmall.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            Flexible(
              child: Text(
                box.law.topic,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(color: colors.muted),
              ),
            ),
            const _MetaDot(),
            Text(
              box.law.article,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(color: colors.muted),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Divider(height: 1, thickness: 1, color: colors.line),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            Text(
              AppStrings.dailyReadFull,
              style: AppTypography.label.copyWith(color: colors.accent),
            ),
            const SizedBox(width: AppSpacing.xs),
            AppIcon(AppIcons.arrowUpRight, size: 16, color: colors.accent),
          ],
        ),
      ],
    );
  }
}

class _OpenedBadge extends StatelessWidget {
  const _OpenedBadge();

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: colors.successSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        AppStrings.dailyOpened.toUpperCase(),
        style: AppTypography.overline.copyWith(color: colors.success),
      ),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();

  static const double _diameter = 3;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Container(
        height: _diameter,
        width: _diameter,
        decoration: BoxDecoration(
          color: colors.muted.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
