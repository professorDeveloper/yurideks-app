import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.obscure = false,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.onSubmitted,
    this.prefix,
    super.key,
  });

  static const double height = 56;

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final bool obscure;
  final String? errorText;
  final String? helperText;
  final bool enabled;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? autofillHints;
  final VoidCallback? onSubmitted;
  final Widget? prefix;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late bool _isObscured = widget.obscure;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final bool hasError = widget.errorText != null;
    final bool isFocused = _focusNode.hasFocus;

    final Color fill = hasError ? colors.dangerSoft : colors.inputFill;
    final Color border = hasError
        ? colors.danger
        : isFocused
            ? colors.accent
            : colors.inputBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: AppTypography.label.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        AnimatedContainer(
          duration: AppDuration.fast,
          curve: Curves.easeOut,
          height: AppTextField.height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(AppRadius.field),
            border: Border.all(
              color: border,
              width: isFocused || hasError ? 1.6 : 1.4,
            ),
          ),
          child: Row(
            children: <Widget>[
              if (widget.prefix != null) ...<Widget>[
                widget.prefix!,
                const SizedBox(width: AppSpacing.md),
                Container(width: 1, height: 22, color: colors.line),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus,
                  obscureText: _isObscured,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  inputFormatters: widget.inputFormatters,
                  autofillHints: widget.autofillHints,
                  onChanged: widget.onChanged,
                  onSubmitted: (_) => widget.onSubmitted?.call(),
                  style: AppTypography.input.copyWith(color: colors.ink),
                  cursorColor: colors.accent,
                  cursorRadius: const Radius.circular(2),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: AppTypography.input.copyWith(
                      color: colors.muted.withValues(alpha: 0.65),
                    ),
                  ),
                ),
              ),
              if (widget.obscure)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _isObscured = !_isObscured),
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: AppIcon(
                      _isObscured ? AppIcons.eye : AppIcons.eyeOff,
                      size: 19,
                      color: colors.muted,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (widget.errorText != null || widget.helperText != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm - 2),
          Text(
            widget.errorText ?? widget.helperText!,
            style: AppTypography.caption.copyWith(
              color: hasError ? colors.danger : colors.muted,
            ),
          ),
        ],
      ],
    );
  }
}
