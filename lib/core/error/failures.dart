import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => const <Object?>[];
}

class ServerFailure extends Failure {
  const ServerFailure();
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class CacheFailure extends Failure {
  const CacheFailure();
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure();
}

class PhoneAlreadyRegisteredFailure extends Failure {
  const PhoneAlreadyRegisteredFailure();
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure();
}

class ValidationFailure extends Failure {
  const ValidationFailure(
      {required this.message, this.fieldErrors = const <String, String>{}});

  final String message;
  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => <Object?>[message, fieldErrors];
}

class ServerMessageFailure extends Failure {
  const ServerMessageFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure(this.retryAfter);

  final Duration retryAfter;

  @override
  List<Object?> get props => <Object?>[retryAfter];
}

class UnknownFailure extends Failure {
  const UnknownFailure();
}
