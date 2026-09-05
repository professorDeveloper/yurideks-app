import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<Either<Failure, AppSettings>> read();

  Future<Either<Failure, AppSettings>> save(AppSettings settings);
}
