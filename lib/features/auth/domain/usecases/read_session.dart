import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class ReadSession implements UseCase<AuthSession?, NoParams> {
  const ReadSession(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthSession?>> call(NoParams params) {
    return _repository.readSession();
  }
}
