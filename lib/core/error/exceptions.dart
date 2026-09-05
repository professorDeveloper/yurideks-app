class ServerException implements Exception {
  const ServerException([this.message]);

  final String? message;
}

class CacheException implements Exception {
  const CacheException([this.message]);

  final String? message;
}

class NetworkException implements Exception {
  const NetworkException([this.message]);

  final String? message;
}

class InvalidCodeException implements Exception {
  const InvalidCodeException();
}

class CodeExpiredException implements Exception {
  const CodeExpiredException();
}

class TooManyRequestsException implements Exception {
  const TooManyRequestsException([this.retryAfter]);

  final Duration? retryAfter;
}
