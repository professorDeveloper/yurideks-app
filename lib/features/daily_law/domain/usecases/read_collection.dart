import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/law_collection.dart';
import '../repositories/daily_law_repository.dart';

class ReadCollection implements UseCase<LawCollection, NoParams> {
  const ReadCollection(this._repository);

  final DailyLawRepository _repository;

  @override
  Future<Either<Failure, LawCollection>> call(NoParams params) {
    return _repository.readCollection();
  }
}
