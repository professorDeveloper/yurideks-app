part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => const <Object?>[];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.settings,
    required this.collectedCount,
    required this.catalogueSize,
    required this.streak,
    this.user,
    this.errorMessage,
  });

  final AppSettings settings;
  final int collectedCount;
  final int catalogueSize;
  final int streak;
  final AuthUser? user;
  final String? errorMessage;

  ProfileLoaded copyWith({AppSettings? settings, String? errorMessage}) {
    return ProfileLoaded(
      settings: settings ?? this.settings,
      collectedCount: collectedCount,
      catalogueSize: catalogueSize,
      streak: streak,
      user: user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        settings,
        collectedCount,
        catalogueSize,
        streak,
        user,
        errorMessage,
      ];
}

class ProfileSignedOut extends ProfileState {
  const ProfileSignedOut();
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
