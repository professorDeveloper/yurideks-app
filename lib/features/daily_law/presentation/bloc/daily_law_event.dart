part of 'daily_law_bloc.dart';

sealed class DailyLawEvent extends Equatable {
  const DailyLawEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

class DailyBoxRequested extends DailyLawEvent {
  const DailyBoxRequested();
}

class DailyBoxOpened extends DailyLawEvent {
  const DailyBoxOpened();
}
