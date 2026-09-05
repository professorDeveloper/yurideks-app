import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/domain/usecases/read_session.dart';
import '../../../intro/domain/usecases/read_intro_seen.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(this._readSession, this._readIntroSeen)
      : super(const SplashInitial()) {
    on<SplashStarted>(_onStarted);
  }

  final ReadSession _readSession;
  final ReadIntroSeen _readIntroSeen;

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    final Future<void> minimumHold = Future<void>.delayed(AppDuration.splash);
    final Either<Failure, AuthSession?> result =
        await _readSession(const NoParams());
    final AuthSession? session = result.fold(
      (Failure failure) => null,
      (AuthSession? value) => value,
    );

    if (session != null) {
      await minimumHold;
      emit(SplashAuthenticated(session));
      return;
    }

    final Either<Failure, bool> seen = await _readIntroSeen(const NoParams());
    await minimumHold;
    emit(
      seen.getOrElse(() => false)
          ? const SplashUnauthenticated()
          : const SplashNeedsIntro(),
    );
  }
}
