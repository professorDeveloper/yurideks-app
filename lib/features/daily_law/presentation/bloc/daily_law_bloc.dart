import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_message.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/daily_box.dart';
import '../../domain/usecases/open_today_box.dart';
import '../../domain/usecases/read_today_box.dart';

part 'daily_law_event.dart';
part 'daily_law_state.dart';

class DailyLawBloc extends Bloc<DailyLawEvent, DailyLawState> {
  DailyLawBloc({
    required ReadTodayBox readTodayBox,
    required OpenTodayBox openTodayBox,
  })  : _readTodayBox = readTodayBox,
        _openTodayBox = openTodayBox,
        super(const DailyLawInitial()) {
    on<DailyBoxRequested>(_onRequested);
    on<DailyBoxOpened>(_onOpened);
  }

  final ReadTodayBox _readTodayBox;
  final OpenTodayBox _openTodayBox;

  Future<void> _onRequested(
    DailyBoxRequested event,
    Emitter<DailyLawState> emit,
  ) async {
    emit(const DailyLawLoading());
    final Either<Failure, DailyBox> result =
        await _readTodayBox(const NoParams());
    emit(_fold(result, justOpened: false));
  }

  Future<void> _onOpened(
    DailyBoxOpened event,
    Emitter<DailyLawState> emit,
  ) async {
    final Either<Failure, DailyBox> result =
        await _openTodayBox(const NoParams());
    emit(_fold(result, justOpened: true));
  }

  DailyLawState _fold(
    Either<Failure, DailyBox> result, {
    required bool justOpened,
  }) {
    return result.fold(
      (Failure failure) => DailyLawError(FailureMessage.of(failure)),
      (DailyBox box) => DailyLawLoaded(box: box, justOpened: justOpened),
    );
  }
}
