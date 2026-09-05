import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/app_icon.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    required this.controller,
    required this.onSubmit,
    this.isEnabled = true,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmit;
  final bool isEnabled;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() => setState(() {});

  bool get _canSend =>
      widget.isEnabled && widget.controller.text.trim().isNotEmpty;

  void _submit() {
    if (!_canSend) {
      return;
    }
    Haptics.impact();
    widget.onSubmit(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.md,
        AppSpacing.screen,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 52),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: colors.line),
                ),
                child: TextField(
                  controller: widget.controller,
                  enabled: widget.isEnabled,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submit(),
                  style: AppTypography.bodySmall.copyWith(color: colors.ink),
                  cursorColor: colors.accent,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: AppStrings.chatHint,
                    hintStyle: AppTypography.bodySmall.copyWith(
                      color: colors.muted,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: _submit,
              child: AnimatedContainer(
                duration: AppDuration.fast,
                height: 52,
                width: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _canSend ? colors.accent : colors.surfaceMuted,
                  shape: BoxShape.circle,
                  border: _canSend ? null : Border.all(color: colors.line),
                ),
                child: AppIcon(
                  AppIcons.arrowUp,
                  size: 22,
                  color: _canSend
                      ? colors.accentInk
                      : colors.muted.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
