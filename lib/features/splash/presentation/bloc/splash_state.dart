part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => const <Object?>[];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashAuthenticated extends SplashState {
  const SplashAuthenticated(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => <Object?>[session];
}

class SplashNeedsIntro extends SplashState {
  const SplashNeedsIntro();
}

class SplashUnauthenticated extends SplashState {
  const SplashUnauthenticated();
}
