part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}

class ProfileLocaleChanged extends ProfileEvent {
  const ProfileLocaleChanged(this.locale);

  final AppLocale locale;

  @override
  List<Object?> get props => <Object?>[locale];
}

class ProfileReminderToggled extends ProfileEvent {
  const ProfileReminderToggled(this.isEnabled);

  final bool isEnabled;

  @override
  List<Object?> get props => <Object?>[isEnabled];
}

class ProfileLoggedOut extends ProfileEvent {
  const ProfileLoggedOut();
}
