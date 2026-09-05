import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/daily_box.dart';
import '../repositories/daily_law_repository.dart';

class ReadTodayBox implements UseCase<DailyBox, NoParams> {
  const ReadTodayBox(this._repository);

  final DailyLawRepository _repository;

  @override
  Future<Either<Failure, DailyBox>> call(NoParams params) {
    return _repository.readTodayBox();
  }
}
