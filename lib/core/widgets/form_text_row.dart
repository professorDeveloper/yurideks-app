import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

class FormTextRow extends StatefulWidget {
  const FormTextRow({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.obscure = false,
    this.hasError = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.onSubmitted,
    this.prefix,
    super.key,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final bool obscure;
  final bool hasError;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? autofillHints;
  final VoidCallback? onSubmitted;
  final Widget? prefix;

  @override
  State<FormTextRow> createState() => _FormTextRowState();
}

class _FormTextRowState extends State<FormTextRow> {
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
    final bool isFocused = _focusNode.hasFocus;
    final Color background = widget.hasError
        ? colors.dangerSoft.withValues(alpha: 0.5)
        : isFocused
            ? colors.accentSoft.withValues(alpha: 0.35)
            : Colors.transparent;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _focusNode.requestFocus,
      child: AnimatedContainer(
        duration: AppDuration.fast,
        curve: Curves.easeOut,
        color: background,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.label,
              style: AppTypography.caption.copyWith(
                color: widget.hasError ? colors.danger : colors.muted,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: <Widget>[
                if (widget.prefix != null) ...<Widget>[
                  widget.prefix!,
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    width: 1,
                    height: 20,
                    color: colors.line,
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
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
                        color: colors.muted.withValues(alpha: 0.5),
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
          ],
        ),
      ),
    );
  }
}
