import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/brand_wordmark.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/intro_slide.dart';
import '../bloc/intro_bloc.dart';
import '../widgets/intro_progress.dart';
import '../widgets/intro_slide_view.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  static const double _wordmarkSize = 19;

  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _page {
    if (!_controller.hasClients || _controller.page == null) {
      return _controller.initialPage.toDouble();
    }
    return _controller.page!;
  }

  void _handleState(BuildContext context, IntroState state) {
    if (state is IntroCompleted) {
      widget.onFinished();
      return;
    }
    if (state is IntroLoaded && state.requestedPage != null) {
      _controller.animateToPage(
        state.requestedPage!,
        duration: AppDuration.base,
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocConsumer<IntroBloc, IntroState>(
          listener: _handleState,
          builder: (BuildContext context, IntroState state) {
            if (state is! IntroLoaded) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const BrandWordmark(fontSize: _wordmarkSize),
                      _SkipButton(
                        onPressed: () =>
                            context.read<IntroBloc>().add(const IntroSkipped()),
                      ),
                    ],
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        return PageView.builder(
                          controller: _controller,
                          itemCount: state.slides.length,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (int page) {
                            Haptics.tap();
                            context
                                .read<IntroBloc>()
                                .add(IntroPageSelected(page));
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final IntroSlide slide = state.slides[index];
                            return IntroSlideView(
                              slide: slide,
                              offset: _page - index,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) =>
                        IntroProgress(count: state.slides.length, page: _page),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: state.isLast
                        ? AppStrings.introStart
                        : AppStrings.introNext,
                    onPressed: () =>
                        context.read<IntroBloc>().add(const IntroAdvanced()),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return TextButton(
      onPressed: () {
        Haptics.tap();
        onPressed();
      },
      style: TextButton.styleFrom(
        foregroundColor: colors.muted,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        AppStrings.introSkip,
        style: AppTypography.caption.copyWith(color: colors.muted),
      ),
    );
  }
}
