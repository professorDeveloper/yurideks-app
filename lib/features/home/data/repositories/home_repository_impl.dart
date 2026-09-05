import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/trending_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._trending);

  final TrendingLocalDataSource _trending;

  @override
  Future<Either<Failure, String>> readTrendingQuestion() async {
    try {
      return Right<Failure, String>(
        await _trending.readQuestionOfTheDay(DateTime.now()),
      );
    } on CacheException {
      return const Left<Failure, Never>(CacheFailure());
    } catch (_) {
      return const Left<Failure, Never>(UnknownFailure());
    }
  }
}
