part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => const <Object?>[];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoaded extends HomeState {
  const HomeLoaded({this.user, this.trendingQuestion});

  final AuthUser? user;
  final String? trendingQuestion;

  @override
  List<Object?> get props => <Object?>[user, trendingQuestion];
}
