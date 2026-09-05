import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class SignInParams extends Equatable {
  const SignInParams({required this.phone, required this.password});

  final String phone;
  final String password;

  @override
  List<Object?> get props => <Object?>[phone, password];
}

class SignIn implements UseCase<AuthSession, SignInParams> {
  const SignIn(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthSession>> call(SignInParams params) {
    return _repository.signIn(
      phone: params.phone,
      password: params.password,
    );
  }
}
