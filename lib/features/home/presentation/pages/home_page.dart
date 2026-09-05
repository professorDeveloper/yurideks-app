import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/initials.dart';
import '../../../../core/widgets/countdown_text.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../daily_law/domain/entities/daily_box.dart';
import '../../../daily_law/presentation/bloc/daily_law_bloc.dart';
import '../../../daily_law/presentation/widgets/daily_box_card.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_ask_hero.dart';
import '../widgets/home_block_skeleton.dart';
import '../widgets/home_daily_skeleton.dart';
import '../widgets/home_quick_chips.dart';
import '../widgets/home_soon_card.dart';
import '../widgets/home_stat_tile.dart';
import '../widgets/home_trending_row.dart';

const EdgeInsets _inset = EdgeInsets.symmetric(horizontal: AppSpacing.screen);

class HomePage extends StatefulWidget {
  const HomePage({
    required this.onAsk,
    required this.onOpenBox,
    required this.onOpenCollection,
    required this.onOpenProfile,
    super.key,
  });

  final ValueChanged<String?> onAsk;
  final VoidCallback onOpenBox;
  final VoidCallback onOpenCollection;
  final VoidCallback onOpenProfile;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<DailyLawBloc>().add(const DailyBoxRequested());
    context.read<HomeBloc>().add(const HomeRequested());
  }

  Future<void> _refresh() async {
    _load();
    await Future<void>.delayed(AppDuration.slow);
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: colors.accent,
        backgroundColor: colors.surface,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: <Widget>[
            _AppBarSliver(onOpenProfile: widget.onOpenProfile),
            const _Gap(AppSpacing.xl),
            _Inline(child: HomeAskHero(onAsk: () => widget.onAsk(null))),
            const _Gap(AppSpacing.xl),
            SliverToBoxAdapter(child: HomeQuickChips(onPick: widget.onAsk)),
            const _Gap(AppSpacing.xxxl),
            _DailySliver(
              onOpenBox: widget.onOpenBox,
              onOpenCollection: widget.onOpenCollection,
            ),
            const _Gap(AppSpacing.xxxl),
            _TrendingSliver(onAsk: widget.onAsk),
            const _Inline(child: HomeSoonCard()),
            const _Gap(AppSpacing.huge),
          ],
        ),
      ),
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap(this.height);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: height));
  }
}

class _Inline extends StatelessWidget {
  const _Inline({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: _inset,
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}

class _AppBarSliver extends StatelessWidget {
  const _AppBarSliver({required this.onOpenProfile});

  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DailyLawBloc, DailyLawState, int>(
      selector: (DailyLawState state) =>
          state is DailyLawLoaded ? state.box.streak : 0,
      builder: (BuildContext context, int streak) {
        return BlocSelector<HomeBloc, HomeState, AuthUser?>(
          selector: (HomeState state) =>
              state is HomeLoaded ? state.user : null,
          builder: (BuildContext context, AuthUser? user) {
            return HomeAppBar(
              now: DateTime.now(),
              name: user?.name,
              streak: streak,
              initials: Initials.of(user?.name),
              onProfile: onOpenProfile,
            );
          },
        );
      },
    );
  }
}

class _DailySliver extends StatelessWidget {
  const _DailySliver({required this.onOpenBox, required this.onOpenCollection});

  static const int _metricCount = 2;

  final VoidCallback onOpenBox;
  final VoidCallback onOpenCollection;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: _inset,
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SectionHeader(
              title: AppStrings.dailyOverline,
              action: AppStrings.homeSeeAll,
              onAction: onOpenCollection,
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<DailyLawBloc, DailyLawState>(
              builder: (BuildContext context, DailyLawState state) {
                return switch (state) {
                  DailyLawLoaded(:final DailyBox box) => _DailyContent(
                      box: box,
                      onOpenBox: onOpenBox,
                      onOpenCollection: onOpenCollection,
                    ),
                  DailyLawError(:final String message) => InlineNotice(
                      message: message,
                    ),
                  _ => const HomeDailySkeleton(metricCount: _metricCount),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyContent extends StatelessWidget {
  const _DailyContent({
    required this.box,
    required this.onOpenBox,
    required this.onOpenCollection,
  });

  final DailyBox box;
  final VoidCallback onOpenBox;
  final VoidCallback onOpenCollection;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DailyBoxCard(box: box, onOpen: onOpenBox),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: HomeStatTile(
                icon: AppIcons.collection,
                label: AppStrings.homeCollectionTitle,
                value: '${box.collectedCount}/${box.catalogueSize}',
                onTap: onOpenCollection,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: HomeStatTile(
                icon: AppIcons.clock,
                label: AppStrings.dailyNextBox,
                valueWidget: CountdownText(
                  target: box.opensAt,
                  style: AppTypography.headline.copyWith(color: colors.ink),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrendingSliver extends StatelessWidget {
  const _TrendingSliver({required this.onAsk});

  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (HomeState previous, HomeState current) =>
          previous.runtimeType != current.runtimeType ||
          (previous is HomeLoaded &&
              current is HomeLoaded &&
              previous.trendingQuestion != current.trendingQuestion),
      builder: (BuildContext context, HomeState state) {
        final String? question =
            state is HomeLoaded ? state.trendingQuestion : null;
        if (state is HomeLoaded && question == null) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverPadding(
          padding: _inset,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SectionHeader(title: AppStrings.trendingOverline),
                const SizedBox(height: AppSpacing.sm),
                if (question == null)
                  const HomeBlockSkeleton(height: HomeTrendingRow.height)
                else
                  HomeTrendingRow(question: question, onAsk: onAsk),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        );
      },
    );
  }
}
