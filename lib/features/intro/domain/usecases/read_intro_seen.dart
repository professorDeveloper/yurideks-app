import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/intro_repository.dart';

class ReadIntroSeen implements UseCase<bool, NoParams> {
  const ReadIntroSeen(this._repository);

  final IntroRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.hasSeenIntro();
  }
}
