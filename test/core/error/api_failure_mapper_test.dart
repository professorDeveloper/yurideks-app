import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/error/api_failure_mapper.dart';
import 'package:yurideks_app/core/error/failures.dart';

DioException _http(
  int status, {
  Map<String, dynamic> body = const <String, dynamic>{},
  Map<String, List<String>> headers = const <String, List<String>>{},
}) {
  final RequestOptions request = RequestOptions(path: '/api/cases');
  return DioException(
    requestOptions: request,
    response: Response<dynamic>(
      requestOptions: request,
      statusCode: status,
      data: body,
      headers: Headers.fromMap(headers),
    ),
  );
}

void main() {
  group('ApiFailureMapper', () {
    test('maps a 401 to invalid credentials', () {
      expect(
        ApiFailureMapper.of(_http(401)),
        isA<InvalidCredentialsFailure>(),
      );
    });

    test('maps a 403 to forbidden', () {
      expect(ApiFailureMapper.of(_http(403)), isA<ForbiddenFailure>());
    });

    test('branches on the code, not the prose, for a taken phone', () {
      final Failure failure = ApiFailureMapper.of(
        _http(
          409,
          body: <String, dynamic>{
            'error': 'Bu raqam band',
            'code': 'errors.phoneTaken',
          },
        ),
      );
      expect(failure, isA<PhoneAlreadyRegisteredFailure>());
    });

    test('keeps field errors from a 400', () {
      final Failure failure = ApiFailureMapper.of(
        _http(
          400,
          body: <String, dynamic>{
            'error': 'Tekshiring',
            'fieldErrors': <String, dynamic>{'password': 'Juda qisqa'},
          },
        ),
      );
      expect(failure, isA<ValidationFailure>());
      final ValidationFailure validation = failure as ValidationFailure;
      expect(validation.message, 'Tekshiring');
      expect(validation.fieldErrors['password'], 'Juda qisqa');
    });

    test('reads Retry-After as whole seconds on a 429', () {
      final Failure failure = ApiFailureMapper.of(
        _http(
          429,
          headers: <String, List<String>>{
            'retry-after': <String>['45'],
          },
        ),
      );
      expect(failure, isA<TooManyRequestsFailure>());
      expect(
        (failure as TooManyRequestsFailure).retryAfter,
        const Duration(seconds: 45),
      );
    });

    test('maps a 500 to a server failure', () {
      expect(ApiFailureMapper.of(_http(500)), isA<ServerFailure>());
    });

    test('treats a connection error as a network failure', () {
      final DioException error = DioException(
        requestOptions: RequestOptions(path: '/api/cases'),
        type: DioExceptionType.connectionError,
      );
      expect(ApiFailureMapper.of(error), isA<NetworkFailure>());
    });

    test('falls back to the server message for an unmapped status', () {
      final Failure failure = ApiFailureMapper.of(
        _http(418, body: <String, dynamic>{'error': 'Choynak'}),
      );
      expect(failure, isA<ServerMessageFailure>());
      expect((failure as ServerMessageFailure).message, 'Choynak');
    });
  });
}
