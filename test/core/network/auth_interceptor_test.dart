import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/network/api_config.dart';
import 'package:yurideks_app/core/network/auth_interceptor.dart';

import '../../support/fake_token_store.dart';

typedef _Handler = Future<ResponseBody> Function(RequestOptions options);

class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.handler);

  final _Handler handler;
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

ResponseBody _json(Map<String, dynamic> body, int status) {
  return ResponseBody.fromString(
    _encode(body),
    status,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}

String _encode(Map<String, dynamic> body) => jsonEncode(body);

void main() {
  late FakeTokenStore store;
  late Dio dio;
  late Dio refreshDio;
  late _ScriptedAdapter adapter;
  late int sessionLost;

  Map<String, dynamic> pairJson(String access) {
    return <String, dynamic>{
      'accessToken': access,
      'refreshToken': 'refresh-2',
      'accessExpiresAt':
          DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      'refreshExpiresAt':
          DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      'user': <String, dynamic>{
        'id': 'u-1',
        'role': 'CITIZEN',
        'phone': '+998901234567',
        'name': 'Dilnoza',
      },
    };
  }

  void wire(_Handler handler) {
    adapter = _ScriptedAdapter(handler);
    dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl))
      ..httpClientAdapter = adapter;
    refreshDio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl))
      ..httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(
        tokenStore: store,
        refreshClient: refreshDio,
        onSessionLost: () async => sessionLost++,
      ),
    );
  }

  setUp(() {
    store = FakeTokenStore(buildPair());
    sessionLost = 0;
  });

  test('attaches the bearer token and required headers', () async {
    wire((RequestOptions options) async => _json(<String, dynamic>{}, 200));

    await dio.get<dynamic>('/api/wallet');

    final RequestOptions sent = adapter.calls.single;
    expect(sent.headers['Authorization'], 'Bearer access-1');
    expect(sent.headers['X-Locale'], ApiConfig.defaultLocale);
    expect(sent.headers['X-Client-Version'], ApiConfig.clientVersion);
  });

  test('never attaches a bearer token to the login route', () async {
    wire((RequestOptions options) async => _json(<String, dynamic>{}, 200));

    await dio.post<dynamic>(ApiConfig.loginPath, data: <String, dynamic>{});

    expect(adapter.calls.single.headers.containsKey('Authorization'), isFalse);
  });

  test('refreshes once and retries the failed request', () async {
    int protectedCalls = 0;
    wire((RequestOptions options) async {
      if (options.path == ApiConfig.refreshPath) {
        return _json(pairJson('access-2'), 200);
      }
      protectedCalls++;
      if (protectedCalls == 1) {
        return _json(<String, dynamic>{'error': 'no', 'code': 'x'}, 401);
      }
      return _json(<String, dynamic>{'ok': true}, 200);
    });

    final Response<dynamic> response = await dio.get<dynamic>('/api/wallet');

    expect(response.statusCode, 200);
    expect(protectedCalls, 2);
    expect(store.writes, 1);
    expect(sessionLost, 0);
  });

  test('runs a single refresh for concurrent 401s', () async {
    int refreshCalls = 0;
    final Map<String, int> attempts = <String, int>{};
    wire((RequestOptions options) async {
      if (options.path == ApiConfig.refreshPath) {
        refreshCalls++;
        await Future<void>.delayed(const Duration(milliseconds: 40));
        return _json(pairJson('access-2'), 200);
      }
      final int seen = (attempts[options.path] ?? 0) + 1;
      attempts[options.path] = seen;
      if (seen == 1) {
        return _json(<String, dynamic>{'error': 'no', 'code': 'x'}, 401);
      }
      return _json(<String, dynamic>{'ok': true}, 200);
    });

    final List<Response<dynamic>> results = await Future.wait(
      <Future<Response<dynamic>>>[
        dio.get<dynamic>('/api/cases'),
        dio.get<dynamic>('/api/wallet'),
        dio.get<dynamic>('/api/documents'),
      ],
    );

    expect(results.every((Response<dynamic> r) => r.statusCode == 200), isTrue);
    expect(refreshCalls, 1);
  });

  test('gives up and reports a lost session when the refresh fails', () async {
    wire((RequestOptions options) async {
      if (options.path == ApiConfig.refreshPath) {
        return _json(<String, dynamic>{'error': 'dead'}, 401);
      }
      return _json(<String, dynamic>{'error': 'no'}, 401);
    });

    await expectLater(
      dio.get<dynamic>('/api/wallet'),
      throwsA(isA<DioException>()),
    );
    expect(sessionLost, 1);
    expect(store.clears, 1);
  });

  test('does not retry a request more than once', () async {
    int protectedCalls = 0;
    wire((RequestOptions options) async {
      if (options.path == ApiConfig.refreshPath) {
        return _json(pairJson('access-2'), 200);
      }
      protectedCalls++;
      return _json(<String, dynamic>{'error': 'no'}, 401);
    });

    await expectLater(
      dio.get<dynamic>('/api/wallet'),
      throwsA(isA<DioException>()),
    );
    expect(protectedCalls, 2);
  });
}
