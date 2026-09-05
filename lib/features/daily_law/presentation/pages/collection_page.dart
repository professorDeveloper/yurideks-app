import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../domain/entities/daily_law.dart';
import '../bloc/collection_bloc.dart';
import '../widgets/collection_tile.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({required this.onOpenLaw, super.key});

  final ValueChanged<DailyLaw> onOpenLaw;

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionBloc>().add(const CollectionRequested());
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CollectionBloc, CollectionState>(
          builder: (BuildContext context, CollectionState state) {
            final List<DailyLaw> laws = switch (state) {
              CollectionLoaded(:final List<DailyLaw> laws) => laws,
              _ => const <DailyLaw>[],
            };
            final int total = switch (state) {
              CollectionLoaded(:final int catalogueSize) => catalogueSize,
              _ => laws.length,
            };

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.lg,
                    AppSpacing.screen,
                    AppSpacing.xl,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.collectionTitle,
                          style: AppTypography.headline.copyWith(
                            color: colors.ink,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${laws.length} / $total '
                          '${AppStrings.collectionSubtitle}',
                          style: AppTypography.caption.copyWith(
                            color: colors.muted,
                          ),
                        ),
                        if (state is CollectionError) ...<Widget>[
                          const SizedBox(height: AppSpacing.lg),
                          InlineNotice(message: state.message),
                        ],
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    0,
                    AppSpacing.screen,
                    AppSpacing.huge,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.92,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index >= laws.length) {
                          return const CollectionTile(law: null);
                        }
                        return CollectionTile(
                          law: laws[index],
                          onTap: () => widget.onOpenLaw(laws[index]),
                        );
                      },
                      childCount: total,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
