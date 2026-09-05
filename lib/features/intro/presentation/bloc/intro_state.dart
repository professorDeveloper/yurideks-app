part of 'intro_bloc.dart';

sealed class IntroState extends Equatable {
  const IntroState();

  @override
  List<Object?> get props => const <Object?>[];
}

class IntroLoaded extends IntroState {
  const IntroLoaded({
    required this.slides,
    required this.page,
    this.requestedPage,
  });

  final List<IntroSlide> slides;
  final int page;
  final int? requestedPage;

  bool get isLast => page == slides.length - 1;

  IntroLoaded copyWith({int? page, int? requestedPage}) {
    return IntroLoaded(
      slides: slides,
      page: page ?? this.page,
      requestedPage: requestedPage,
    );
  }

  @override
  List<Object?> get props => <Object?>[slides, page, requestedPage];
}

class IntroCompleted extends IntroState {
  const IntroCompleted();
}
