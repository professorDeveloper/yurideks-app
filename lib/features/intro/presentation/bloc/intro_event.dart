part of 'intro_bloc.dart';

sealed class IntroEvent extends Equatable {
  const IntroEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

class IntroPageSelected extends IntroEvent {
  const IntroPageSelected(this.page);

  final int page;

  @override
  List<Object?> get props => <Object?>[page];
}

class IntroAdvanced extends IntroEvent {
  const IntroAdvanced();
}

class IntroSkipped extends IntroEvent {
  const IntroSkipped();
}
