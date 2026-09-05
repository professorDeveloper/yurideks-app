class ApiError implements Exception {
  const ApiError({
    required this.statusCode,
    required this.message,
    this.code,
    this.fieldErrors = const <String, String>{},
    this.retryAfter,
  });

  final int statusCode;
  final String message;
  final String? code;
  final Map<String, String> fieldErrors;
  final Duration? retryAfter;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'ApiError($statusCode, $code, $message)';
}
