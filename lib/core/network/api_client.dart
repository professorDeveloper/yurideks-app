import 'package:dio/dio.dart';

import 'api_config.dart';
import 'auth_interceptor.dart';
import 'token_store.dart';

class ApiClient {
  ApiClient({required TokenStore tokenStore, required this.onSessionLost})
      : _dio = Dio(_options()),
        _refreshDio = Dio(_options()) {
    _interceptor = AuthInterceptor(
      tokenStore: tokenStore,
      refreshClient: _refreshDio,
      onSessionLost: onSessionLost,
    );
    _dio.interceptors.add(_interceptor);
  }

  static BaseOptions _options() {
    return BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      contentType: Headers.jsonContentType,
    );
  }

  final Dio _dio;
  final Dio _refreshDio;
  final Future<void> Function() onSessionLost;

  late final AuthInterceptor _interceptor;

  set locale(String value) => _interceptor.locale = value;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) {
    return _dio.get<dynamic>(path, queryParameters: query);
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? headers,
  }) {
    return _dio.post<dynamic>(
      path,
      data: body,
      options: headers == null ? null : Options(headers: headers),
    );
  }
}
