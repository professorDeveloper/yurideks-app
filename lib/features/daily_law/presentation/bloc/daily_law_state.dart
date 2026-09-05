part of 'daily_law_bloc.dart';

sealed class DailyLawState extends Equatable {
  const DailyLawState();

  @override
  List<Object?> get props => const <Object?>[];
}

class DailyLawInitial extends DailyLawState {
  const DailyLawInitial();
}

class DailyLawLoading extends DailyLawState {
  const DailyLawLoading();
}

class DailyLawLoaded extends DailyLawState {
  const DailyLawLoaded({required this.box, this.justOpened = false});

  final DailyBox box;
  final bool justOpened;

  @override
  List<Object?> get props => <Object?>[box, justOpened];
}

class DailyLawError extends DailyLawState {
  const DailyLawError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
