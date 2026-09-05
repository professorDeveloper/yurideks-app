import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/auth_session.dart';
import '../bloc/auth_field.dart';
import '../bloc/login/login_bloc.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_masthead.dart';
import '../widgets/auth_switch_link.dart';
import '../widgets/dial_code.dart';
import '../widgets/forgot_password_link.dart';
import '../widgets/forgot_password_sheet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.onSignedIn,
    required this.onSignUpRequested,
    super.key,
  });

  final ValueChanged<AuthSession> onSignedIn;
  final VoidCallback onSignUpRequested;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<LoginBloc>().add(const LoginSubmitted());
  }

  void _handleState(BuildContext context, LoginState state) {
    if (state.status == LoginStatus.succeeded && state.session != null) {
      Haptics.success();
      widget.onSignedIn(state.session!);
      return;
    }
    if (state.status == LoginStatus.failed) {
      Haptics.error();
      if (state.hasFieldError(AuthField.password)) {
        _passwordFocus.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: _handleState,
          builder: (BuildContext context, LoginState state) {
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
                          const AuthMasthead(),
                          const SizedBox(height: AppSpacing.xxl),
                          _LoginForm(
                            state: state,
                            phoneController: _phoneController,
                            passwordController: _passwordController,
                            phoneFocus: _phoneFocus,
                            passwordFocus: _passwordFocus,
                            onSubmit: _submit,
                            onSignUpRequested: widget.onSignUpRequested,
                          ),
                          const Spacer(),
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

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.state,
    required this.phoneController,
    required this.passwordController,
    required this.phoneFocus,
    required this.passwordFocus,
    required this.onSubmit,
    required this.onSignUpRequested,
  });

  final LoginState state;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode phoneFocus;
  final FocusNode passwordFocus;
  final VoidCallback onSubmit;
  final VoidCallback onSignUpRequested;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const AuthHeader(title: AppStrings.loginTitle),
        const SizedBox(height: AppSpacing.xl),
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
              context.read<LoginBloc>().add(LoginPhoneChanged(value)),
          onSubmitted: passwordFocus.requestFocus,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: AppStrings.passwordLabel,
          hint: AppStrings.passwordHint,
          controller: passwordController,
          focusNode: passwordFocus,
          enabled: !state.isSubmitting,
          errorText: state.fieldErrors[AuthField.password],
          obscure: true,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.password],
          onChanged: (String value) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(value)),
          onSubmitted: onSubmit,
        ),
        AnimatedSize(
          duration: AppDuration.base,
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: state.errorMessage == null || state.hasAnyFieldError
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: InlineNotice(message: state.errorMessage!),
                ),
        ),
        ForgotPasswordLink(
          onPressed: () => ForgotPasswordSheet.show(context),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: AppStrings.loginAction,
          isLoading: state.isSubmitting,
          onPressed: onSubmit,
        ),
        const SizedBox(height: AppSpacing.md),
        AuthSwitchLink(
          question: AppStrings.loginNoAccount,
          action: AppStrings.loginSignUpLink,
          onPressed: onSignUpRequested,
        ),
      ],
    );
  }
}
