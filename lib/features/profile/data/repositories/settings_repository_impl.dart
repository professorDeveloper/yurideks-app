import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local, this._client);

  final SettingsLocalDataSource _local;
  final ApiClient _client;

  @override
  Future<Either<Failure, AppSettings>> read() {
    return _guard(() async {
      final AppSettings settings = await _local.read();
      _client.locale = settings.locale.code;
      return settings;
    });
  }

  @override
  Future<Either<Failure, AppSettings>> save(AppSettings settings) {
    return _guard(() async {
      await _local.write(settings);
      _client.locale = settings.locale.code;
      return settings;
    });
  }

  Future<Either<Failure, AppSettings>> _guard(
    Future<AppSettings> Function() action,
  ) async {
    try {
      return Right<Failure, AppSettings>(await action());
    } on CacheException {
      return const Left<Failure, Never>(CacheFailure());
    } catch (_) {
      return const Left<Failure, Never>(UnknownFailure());
    }
  }
}
