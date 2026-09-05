import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/intro_catalogue.dart';
import '../../domain/entities/intro_slide.dart';
import '../../domain/usecases/mark_intro_seen.dart';

part 'intro_event.dart';
part 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  IntroBloc(this._markIntroSeen)
      : super(const IntroLoaded(slides: IntroCatalogue.slides, page: 0)) {
    on<IntroPageSelected>(_onPageSelected);
    on<IntroAdvanced>(_onAdvanced);
    on<IntroSkipped>(_onSkipped);
  }

  final MarkIntroSeen _markIntroSeen;

  void _onPageSelected(IntroPageSelected event, Emitter<IntroState> emit) {
    final IntroState current = state;
    if (current is! IntroLoaded || current.page == event.page) {
      return;
    }
    emit(current.copyWith(page: event.page));
  }

  Future<void> _onAdvanced(
    IntroAdvanced event,
    Emitter<IntroState> emit,
  ) async {
    final IntroState current = state;
    if (current is! IntroLoaded) {
      return;
    }
    if (!current.isLast) {
      emit(
        current.copyWith(
          page: current.page + 1,
          requestedPage: current.page + 1,
        ),
      );
      return;
    }
    await _complete(emit);
  }

  Future<void> _onSkipped(IntroSkipped event, Emitter<IntroState> emit) {
    return _complete(emit);
  }

  Future<void> _complete(Emitter<IntroState> emit) async {
    await _markIntroSeen(const NoParams());
    emit(const IntroCompleted());
  }
}
