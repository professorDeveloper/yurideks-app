import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../bloc/splash_bloc.dart';
import '../widgets/splash_stage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    required this.onAuthenticated,
    required this.onIntroNeeded,
    required this.onUnauthenticated,
    super.key,
  });

  final VoidCallback onAuthenticated;
  final VoidCallback onIntroNeeded;
  final VoidCallback onUnauthenticated;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDuration.splash,
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleState(BuildContext context, SplashState state) {
    switch (state) {
      case SplashInitial():
        return;
      case SplashAuthenticated():
        widget.onAuthenticated();
      case SplashNeedsIntro():
        widget.onIntroNeeded();
      case SplashUnauthenticated():
        widget.onUnauthenticated();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return BlocListener<SplashBloc, SplashState>(
      listener: _handleState,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(child: SplashStage(animation: _controller)),
      ),
    );
  }
}
