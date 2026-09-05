import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthSession>> signUp({
    required String name,
    required String phone,
    required String password,
  });

  Future<Either<Failure, AuthSession>> signIn({
    required String phone,
    required String password,
  });

  Future<Either<Failure, AuthSession?>> readSession();

  Future<Either<Failure, Unit>> signOut();
}
