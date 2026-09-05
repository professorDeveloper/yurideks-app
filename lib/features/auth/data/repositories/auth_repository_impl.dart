import 'package:dartz/dartz.dart';

import '../../../../core/error/api_failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/token_pair_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._local);

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Either<Failure, AuthSession>> signUp({
    required String name,
    required String phone,
    required String password,
  }) {
    return _guard(() async {
      final TokenPairModel pair = await _remote.signUp(
        name: name,
        phone: phone,
        password: password,
      );
      await _local.writeSession(pair);
      return pair;
    });
  }

  @override
  Future<Either<Failure, AuthSession>> signIn({
    required String phone,
    required String password,
  }) {
    return _guard(() async {
      final TokenPairModel pair = await _remote.signIn(
        phone: phone,
        password: password,
      );
      await _local.writeSession(pair);
      return pair;
    });
  }

  @override
  Future<Either<Failure, AuthSession?>> readSession() {
    return _guard(() async {
      final TokenPairModel? pair = await _local.readSession();
      if (pair == null || !pair.isRefreshUsable) {
        return null;
      }
      return pair;
    });
  }

  @override
  Future<Either<Failure, Unit>> signOut() {
    return _guard(() async {
      final TokenPairModel? pair = await _local.readSession();
      if (pair != null) {
        try {
          await _remote.signOut(pair.refreshToken);
        } on Object {
          await _local.clearSession();
        }
      }
      await _local.clearSession();
      return unit;
    });
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right<Failure, T>(await action());
    } on Object catch (error) {
      return Left<Failure, T>(ApiFailureMapper.of(error));
    }
  }
}
