import '../constants/app_strings.dart';
import 'failures.dart';

abstract final class FailureMessage {
  static String of(Failure failure) {
    return switch (failure) {
      NetworkFailure() => AppStrings.networkFailure,
      ServerFailure() => AppStrings.serverFailure,
      CacheFailure() => AppStrings.serverFailure,
      InvalidCredentialsFailure() => AppStrings.invalidCredentials,
      PhoneAlreadyRegisteredFailure() => AppStrings.phoneAlreadyRegistered,
      ForbiddenFailure() => AppStrings.forbidden,
      ValidationFailure(:final String message) => message,
      ServerMessageFailure(:final String message) => message,
      TooManyRequestsFailure() => AppStrings.tooManyAttempts,
      UnknownFailure() => AppStrings.unknownFailure,
    };
  }
}
