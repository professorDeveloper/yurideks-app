import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/intro_repository.dart';

class MarkIntroSeen implements UseCase<Unit, NoParams> {
  const MarkIntroSeen(this._repository);

  final IntroRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.markIntroSeen();
  }
}
