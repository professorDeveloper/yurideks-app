import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/form_group.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/settings_row.dart';
import '../../domain/entities/app_settings.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/language_sheet.dart';
import '../widgets/logout_sheet.dart';
import '../widgets/profile_identity.dart';
import '../widgets/profile_stats.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.onSignedOut, super.key});

  final VoidCallback onSignedOut;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileRequested());
  }

  Future<void> _pickLanguage(AppLocale current) async {
    Haptics.tap();
    final AppLocale? picked = await showModalBottomSheet<AppLocale>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) => LanguageSheet(selected: current),
    );
    if (picked != null && picked != current && mounted) {
      context.read<ProfileBloc>().add(ProfileLocaleChanged(picked));
    }
  }

  Future<void> _confirmSignOut() async {
    Haptics.tap();
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) => const LogoutSheet(),
    );
    if ((confirmed ?? false) && mounted) {
      context.read<ProfileBloc>().add(const ProfileLoggedOut());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (BuildContext context, ProfileState state) {
            if (state is ProfileSignedOut) {
              widget.onSignedOut();
            }
          },
          builder: (BuildContext context, ProfileState state) {
            if (state is! ProfileLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return _Body(
              state: state,
              onLanguage: () => _pickLanguage(state.settings.locale),
              onReminder: (bool value) => context.read<ProfileBloc>().add(
                    ProfileReminderToggled(value),
                  ),
              onSignOut: _confirmSignOut,
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.onLanguage,
    required this.onReminder,
    required this.onSignOut,
  });

  final ProfileLoaded state;
  final VoidCallback onLanguage;
  final ValueChanged<bool> onReminder;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.xl,
        AppSpacing.screen,
        AppSpacing.huge,
      ),
      children: <Widget>[
        ProfileIdentity(
          name: state.user?.name,
          phone: state.user?.phone ?? '—',
        ),
        const SizedBox(height: AppSpacing.xl),
        ProfileStats(
          collected: state.collectedCount,
          total: state.catalogueSize,
          streak: state.streak,
        ),
        if (state.errorMessage != null) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          InlineNotice(message: state.errorMessage!),
        ],
        const SizedBox(height: AppSpacing.xxl),
        const SectionLabel(text: AppStrings.profileSettings),
        const SizedBox(height: AppSpacing.md),
        FormGroup(
          rows: <Widget>[
            SettingsRow(
              icon: AppIcons.language,
              title: AppStrings.profileLanguage,
              value: AppStrings.languages[state.settings.locale.index],
              onTap: onLanguage,
            ),
            SettingsRow(
              icon: AppIcons.gift,
              title: AppStrings.profileDailyReminder,
              trailing: CupertinoSwitch(
                value: state.settings.dailyReminder,
                activeTrackColor: colors.accent,
                onChanged: (bool next) {
                  Haptics.tap();
                  onReminder(next);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        const SectionLabel(text: AppStrings.profileSupport),
        const SizedBox(height: AppSpacing.md),
        FormGroup(
          rows: <Widget>[
            SettingsRow(
              icon: AppIcons.article,
              title: AppStrings.profileTerms,
              onTap: Haptics.tap,
            ),
            SettingsRow(
              icon: AppIcons.shield,
              title: AppStrings.profilePrivacy,
              onTap: Haptics.tap,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        FormGroup(
          rows: <Widget>[
            SettingsRow(
              icon: AppIcons.signOut,
              title: AppStrings.profileLogout,
              isDanger: true,
              onTap: onSignOut,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Text(
            '${AppStrings.profileVersion} 1.0.0',
            style: AppTypography.caption.copyWith(
              color: colors.muted.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}
