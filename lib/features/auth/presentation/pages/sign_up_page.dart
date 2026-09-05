import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/auth_session.dart';
import '../bloc/auth_field.dart';
import '../bloc/sign_up/sign_up_bloc.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_switch_link.dart';
import '../widgets/dial_code.dart';
import '../widgets/legal_consent.dart';
import '../widgets/password_rule.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    required this.onSignedUp,
    required this.onLoginRequested,
    super.key,
  });

  final ValueChanged<AuthSession> onSignedUp;
  final VoidCallback onLoginRequested;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<SignUpBloc>().add(const SignUpSubmitted());
  }

  void _handleState(BuildContext context, SignUpState state) {
    if (state.status == SignUpStatus.succeeded && state.session != null) {
      Haptics.success();
      widget.onSignedUp(state.session!);
      return;
    }
    if (state.status != SignUpStatus.failed) {
      return;
    }
    Haptics.error();
    _focusFirstError(state);
  }

  void _focusFirstError(SignUpState state) {
    if (state.fieldErrors.containsKey(AuthField.name)) {
      _nameFocus.requestFocus();
      return;
    }
    if (state.fieldErrors.containsKey(AuthField.phone)) {
      _phoneFocus.requestFocus();
      return;
    }
    if (state.fieldErrors.containsKey(AuthField.password)) {
      _passwordFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: _handleState,
          builder: (BuildContext context, SignUpState state) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.lg,
                    AppSpacing.screen,
                    AppSpacing.xl,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight - AppSpacing.lg - AppSpacing.xl,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: _SignUpForm(
                              state: state,
                              nameController: _nameController,
                              phoneController: _phoneController,
                              passwordController: _passwordController,
                              nameFocus: _nameFocus,
                              phoneFocus: _phoneFocus,
                              passwordFocus: _passwordFocus,
                              onSubmit: _submit,
                              onLoginRequested: widget.onLoginRequested,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          const AuthFooter(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({
    required this.state,
    required this.nameController,
    required this.phoneController,
    required this.passwordController,
    required this.nameFocus,
    required this.phoneFocus,
    required this.passwordFocus,
    required this.onSubmit,
    required this.onLoginRequested,
  });

  final SignUpState state;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode nameFocus;
  final FocusNode phoneFocus;
  final FocusNode passwordFocus;
  final VoidCallback onSubmit;
  final VoidCallback onLoginRequested;

  @override
  Widget build(BuildContext context) {
    final bool isPasswordValid =
        state.password.length >= SignUpState.minimumPasswordLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: AppBackButton(onPressed: onLoginRequested),
        ),
        const SizedBox(height: AppSpacing.md),
        const AuthHeader(title: AppStrings.signUpTitle),
        const SizedBox(height: AppSpacing.xl),
        AppTextField(
          label: AppStrings.nameLabel,
          hint: AppStrings.nameHint,
          controller: nameController,
          focusNode: nameFocus,
          enabled: !state.isSubmitting,
          errorText: state.fieldErrors[AuthField.name],
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          autofillHints: const <String>[AutofillHints.name],
          onChanged: (String value) =>
              context.read<SignUpBloc>().add(SignUpNameChanged(value)),
          onSubmitted: phoneFocus.requestFocus,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: AppStrings.phoneFieldLabel,
          hint: AppStrings.phoneHint,
          controller: phoneController,
          focusNode: phoneFocus,
          enabled: !state.isSubmitting,
          errorText: state.fieldErrors[AuthField.phone],
          prefix: const DialCode(),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          inputFormatters: <TextInputFormatter>[UzbekPhoneFormatter()],
          autofillHints: const <String>[AutofillHints.telephoneNumber],
          onChanged: (String value) =>
              context.read<SignUpBloc>().add(SignUpPhoneChanged(value)),
          onSubmitted: passwordFocus.requestFocus,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: AppStrings.passwordLabel,
          hint: AppStrings.passwordCreateHint,
          controller: passwordController,
          focusNode: passwordFocus,
          enabled: !state.isSubmitting,
          errorText: state.fieldErrors[AuthField.password],
          obscure: true,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.newPassword],
          onChanged: (String value) =>
              context.read<SignUpBloc>().add(SignUpPasswordChanged(value)),
          onSubmitted: onSubmit,
        ),
        const SizedBox(height: AppSpacing.md),
        PasswordRule(
          label: AppStrings.passwordHint,
          isSatisfied: isPasswordValid,
        ),
        AnimatedSize(
          duration: AppDuration.base,
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: state.errorMessage == null || state.fieldErrors.isNotEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: InlineNotice(message: state.errorMessage!),
                ),
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: AppStrings.signUpAction,
          isLoading: state.isSubmitting,
          onPressed: onSubmit,
        ),
        const SizedBox(height: AppSpacing.md),
        const LegalConsent(),
        const SizedBox(height: AppSpacing.sm),
        AuthSwitchLink(
          question: AppStrings.signUpHaveAccount,
          action: AppStrings.signUpLoginLink,
          onPressed: onLoginRequested,
        ),
        const Spacer(),
      ],
    );
  }
}
