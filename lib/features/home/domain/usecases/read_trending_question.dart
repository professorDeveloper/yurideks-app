import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/home_repository.dart';

class ReadTrendingQuestion implements UseCase<String, NoParams> {
  const ReadTrendingQuestion(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return _repository.readTrendingQuestion();
  }
}
