import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract interface class IntroRepository {
  Future<Either<Failure, bool>> hasSeenIntro();

  Future<Either<Failure, Unit>> markIntroSeen();
}
