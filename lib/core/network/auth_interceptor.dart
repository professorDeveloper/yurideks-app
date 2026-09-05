import 'dart:async';

import 'package:dio/dio.dart';

import '../../features/auth/data/models/token_pair_model.dart';
import 'api_config.dart';
import 'token_store.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStore tokenStore,
    required Dio refreshClient,
    required this.onSessionLost,
  })  : _tokenStore = tokenStore,
        _refreshClient = refreshClient;

  final TokenStore _tokenStore;
  final Dio _refreshClient;
  final Future<void> Function() onSessionLost;

  Future<TokenPairModel?>? _inFlightRefresh;
  String _locale = ApiConfig.defaultLocale;

  set locale(String value) => _locale = value;

  bool _isAuthRoute(String path) {
    return path == ApiConfig.loginPath ||
        path == ApiConfig.signupPath ||
        path == ApiConfig.refreshPath;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['X-Locale'] = _locale;
    options.headers['X-Client-Version'] = ApiConfig.clientVersion;

    if (!_isAuthRoute(options.path)) {
      final TokenPairModel? pair = await _tokenStore.read();
      if (pair != null) {
        options.headers['Authorization'] = 'Bearer ${pair.accessToken}';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final RequestOptions request = err.requestOptions;
    final bool isRetryable = err.response?.statusCode == 401 &&
        !_isAuthRoute(request.path) &&
        request.extra['retried'] != true;

    if (!isRetryable) {
      handler.next(err);
      return;
    }

    final TokenPairModel? refreshed = await _refreshOnce();
    if (refreshed == null) {
      await onSessionLost();
      handler.next(err);
      return;
    }

    request.extra['retried'] = true;
    request.headers['Authorization'] = 'Bearer ${refreshed.accessToken}';
    try {
      final Response<dynamic> response = await _refreshClient.fetch<dynamic>(
        request,
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<TokenPairModel?> _refreshOnce() {
    return _inFlightRefresh ??= _performRefresh().whenComplete(() {
      _inFlightRefresh = null;
    });
  }

  Future<TokenPairModel?> _performRefresh() async {
    final TokenPairModel? current = await _tokenStore.read();
    if (current == null || !current.isRefreshUsable) {
      return null;
    }
    try {
      final Response<dynamic> response = await _refreshClient.post<dynamic>(
        ApiConfig.refreshPath,
        data: <String, dynamic>{'refreshToken': current.refreshToken},
        options: Options(
          headers: <String, dynamic>{
            'X-Locale': _locale,
            'X-Client-Version': ApiConfig.clientVersion,
          },
        ),
      );
      final TokenPairModel pair = TokenPairModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      await _tokenStore.write(pair);
      return pair;
    } on DioException {
      await _tokenStore.clear();
      return null;
    }
  }
}
