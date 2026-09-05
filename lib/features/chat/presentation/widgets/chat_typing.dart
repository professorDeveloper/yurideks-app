import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ChatTyping extends StatefulWidget {
  const ChatTyping({super.key});

  @override
  State<ChatTyping> createState() => _ChatTypingState();
}

class _ChatTypingState extends State<ChatTyping>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (int index = 0; index < 3; index++)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: Opacity(
                          opacity: 0.35 +
                              0.65 *
                                  (0.5 +
                                      0.5 *
                                          math.sin(
                                            (_controller.value - index * 0.18) *
                                                math.pi *
                                                2,
                                          )),
                          child: Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              color: colors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              AppStrings.chatThinking,
              style: AppTypography.caption.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
