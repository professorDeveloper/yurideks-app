import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_message.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/domain/usecases/read_session.dart';
import '../../../auth/domain/usecases/sign_out.dart';
import '../../../daily_law/domain/entities/daily_box.dart';
import '../../../daily_law/domain/usecases/read_today_box.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/read_settings.dart';
import '../../domain/usecases/save_settings.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required ReadSession readSession,
    required SignOut signOut,
    required ReadSettings readSettings,
    required SaveSettings saveSettings,
    required ReadTodayBox readTodayBox,
  })  : _readSession = readSession,
        _signOut = signOut,
        _readSettings = readSettings,
        _saveSettings = saveSettings,
        _readTodayBox = readTodayBox,
        super(const ProfileInitial()) {
    on<ProfileRequested>(_onRequested);
    on<ProfileLocaleChanged>(_onLocaleChanged);
    on<ProfileReminderToggled>(_onReminderToggled);
    on<ProfileLoggedOut>(_onLoggedOut);
  }

  final ReadSession _readSession;
  final SignOut _signOut;
  final ReadSettings _readSettings;
  final SaveSettings _saveSettings;
  final ReadTodayBox _readTodayBox;

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final Either<Failure, AuthSession?> session = await _readSession(
      const NoParams(),
    );
    final Either<Failure, AppSettings> settings = await _readSettings(
      const NoParams(),
    );
    final Either<Failure, DailyBox> box = await _readTodayBox(const NoParams());

    emit(
      ProfileLoaded(
        settings: settings.getOrElse(() => const AppSettings()),
        collectedCount: box.fold(
          (Failure failure) => 0,
          (DailyBox value) => value.collectedCount,
        ),
        catalogueSize: box.fold(
          (Failure failure) => 0,
          (DailyBox value) => value.catalogueSize,
        ),
        streak: box.fold(
          (Failure failure) => 0,
          (DailyBox value) => value.streak,
        ),
        user: session.fold(
          (Failure failure) => null,
          (AuthSession? value) => value?.user,
        ),
      ),
    );
  }

  Future<void> _onLocaleChanged(
    ProfileLocaleChanged event,
    Emitter<ProfileState> emit,
  ) {
    return _persist(emit, (AppSettings current) {
      return current.copyWith(locale: event.locale);
    });
  }

  Future<void> _onReminderToggled(
    ProfileReminderToggled event,
    Emitter<ProfileState> emit,
  ) {
    return _persist(emit, (AppSettings current) {
      return current.copyWith(dailyReminder: event.isEnabled);
    });
  }

  Future<void> _persist(
    Emitter<ProfileState> emit,
    AppSettings Function(AppSettings current) change,
  ) async {
    final ProfileState state = this.state;
    if (state is! ProfileLoaded) {
      return;
    }
    final AppSettings next = change(state.settings);
    emit(state.copyWith(settings: next));

    final Either<Failure, AppSettings> result = await _saveSettings(next);
    result.fold(
      (Failure failure) => emit(
        state.copyWith(
          settings: state.settings,
          errorMessage: FailureMessage.of(failure),
        ),
      ),
      (AppSettings saved) => null,
    );
  }

  Future<void> _onLoggedOut(
    ProfileLoggedOut event,
    Emitter<ProfileState> emit,
  ) async {
    final Either<Failure, Unit> result = await _signOut(const NoParams());
    emit(
      result.fold(
        (Failure failure) => ProfileError(FailureMessage.of(failure)),
        (Unit _) => const ProfileSignedOut(),
      ),
    );
  }
}
