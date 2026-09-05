import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:yurideks_app/core/network/api_client.dart';
import 'package:yurideks_app/core/network/api_config.dart';

typedef ScriptedHandler = Future<ResponseBody> Function(RequestOptions options);

class ScriptedAdapter implements HttpClientAdapter {
  ScriptedAdapter(this.handler);

  final ScriptedHandler handler;
  final List<RequestOptions> calls = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    calls.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(Map<String, dynamic> body, int status) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}

class ScriptedApiClient implements ApiClient {
  ScriptedApiClient(ScriptedHandler handler)
      : adapter = ScriptedAdapter(handler),
        _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)) {
    _dio.httpClientAdapter = adapter;
  }

  final ScriptedAdapter adapter;
  final Dio _dio;

  List<RequestOptions> get calls => adapter.calls;

  @override
  set locale(String value) {}

  @override
  Future<void> Function() get onSessionLost => () async {};

  @override
  Future<Response<dynamic>> get(String path, {Map<String, dynamic>? query}) {
    return _dio.get<dynamic>(path, queryParameters: query);
  }

  @override
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
