import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/domain/usecases/read_session.dart';
import '../../domain/usecases/read_trending_question.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required ReadSession readSession,
    required ReadTrendingQuestion readTrendingQuestion,
  })  : _readSession = readSession,
        _readTrendingQuestion = readTrendingQuestion,
        super(const HomeInitial()) {
    on<HomeRequested>(_onRequested);
  }

  final ReadSession _readSession;
  final ReadTrendingQuestion _readTrendingQuestion;

  Future<void> _onRequested(
    HomeRequested event,
    Emitter<HomeState> emit,
  ) async {
    final Either<Failure, AuthSession?> session =
        await _readSession(const NoParams());
    final Either<Failure, String> trending =
        await _readTrendingQuestion(const NoParams());

    emit(
      HomeLoaded(
        user: session.fold(
          (Failure failure) => null,
          (AuthSession? value) => value?.user,
        ),
        trendingQuestion: trending.fold(
          (Failure failure) => null,
          (String value) => value,
        ),
      ),
    );
  }
}
