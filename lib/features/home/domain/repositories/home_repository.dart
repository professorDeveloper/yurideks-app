import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, String>> readTrendingQuestion();
}
