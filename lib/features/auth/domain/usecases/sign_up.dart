import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.name,
    required this.phone,
    required this.password,
  });

  final String name;
  final String phone;
  final String password;

  @override
  List<Object?> get props => <Object?>[name, phone, password];
}

class SignUp implements UseCase<AuthSession, SignUpParams> {
  const SignUp(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthSession>> call(SignUpParams params) {
    return _repository.signUp(
      name: params.name,
      phone: params.phone,
      password: params.password,
    );
  }
}
