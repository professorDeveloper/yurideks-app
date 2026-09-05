import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/intro_repository.dart';
import '../datasources/intro_local_data_source.dart';

class IntroRepositoryImpl implements IntroRepository {
  const IntroRepositoryImpl(this._local);

  final IntroLocalDataSource _local;

  @override
  Future<Either<Failure, bool>> hasSeenIntro() async {
    try {
      return Right<Failure, bool>(await _local.readSeen());
    } on CacheException {
      return const Left<Failure, Never>(CacheFailure());
    } catch (_) {
      return const Left<Failure, Never>(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> markIntroSeen() async {
    try {
      await _local.writeSeen();
      return const Right<Failure, Unit>(unit);
    } on CacheException {
      return const Left<Failure, Never>(CacheFailure());
    } catch (_) {
      return const Left<Failure, Never>(UnknownFailure());
    }
  }
}
