import 'package:dio/dio.dart';

import '../constants/app_strings.dart';
import '../error/api_error.dart';

abstract final class ApiErrorParser {
  static ApiError from(DioException exception) {
    final Response<dynamic>? response = exception.response;
    if (response == null) {
      return const ApiError(statusCode: 0, message: AppStrings.networkFailure);
    }

    final dynamic body = response.data;
    final Map<String, dynamic> payload =
        body is Map<String, dynamic> ? body : const <String, dynamic>{};

    return ApiError(
      statusCode: response.statusCode ?? 0,
      message: (payload['error'] as String?) ?? AppStrings.serverFailure,
      code: payload['code'] as String?,
      fieldErrors: _fieldErrors(payload['fieldErrors']),
      retryAfter: _retryAfter(response.headers.value('retry-after')),
    );
  }

  static Map<String, String> _fieldErrors(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return const <String, String>{};
    }
    return raw.map(
      (String key, dynamic value) => MapEntry<String, String>(
        key,
        value.toString(),
      ),
    );
  }

  static Duration? _retryAfter(String? header) {
    final int? seconds = header == null ? null : int.tryParse(header);
    return seconds == null ? null : Duration(seconds: seconds);
  }
}
