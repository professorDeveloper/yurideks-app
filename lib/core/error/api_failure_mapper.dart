import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../network/api_error_parser.dart';
import 'api_error.dart';
import 'exceptions.dart';
import 'failures.dart';

abstract final class ApiFailureMapper {
  static Failure of(Object error) {
    return switch (error) {
      DioException() => _fromDio(error),
      CacheException() => const CacheFailure(),
      SocketException() => const NetworkFailure(),
      TimeoutException() => const NetworkFailure(),
      _ => const UnknownFailure(),
    };
  }

  static Failure _fromDio(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const NetworkFailure();
    }

    final ApiError parsed = ApiErrorParser.from(error);
    return switch (parsed.statusCode) {
      401 => const InvalidCredentialsFailure(),
      403 => const ForbiddenFailure(),
      409 when parsed.code == 'errors.phoneTaken' =>
        const PhoneAlreadyRegisteredFailure(),
      400 || 409 => ValidationFailure(
          message: parsed.message,
          fieldErrors: parsed.fieldErrors,
        ),
      429 => TooManyRequestsFailure(
          parsed.retryAfter ?? const Duration(minutes: 1),
        ),
      >= 500 => const ServerFailure(),
      0 => const NetworkFailure(),
      _ => ServerMessageFailure(parsed.message),
    };
  }
}
