import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/network/api_client.dart';
import 'package:yurideks_app/core/network/api_config.dart';
import 'package:yurideks_app/features/daily_law/data/datasources/daily_law_bundle_data_source.dart';
import 'package:yurideks_app/features/daily_law/data/datasources/daily_law_catalogue_data_source.dart';
import 'package:yurideks_app/features/daily_law/data/datasources/daily_law_remote_data_source.dart';
import 'package:yurideks_app/features/daily_law/data/models/daily_law_model.dart';

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

class _ScriptedApiClient implements ApiClient {
  _ScriptedApiClient(this._dio);

  final Dio _dio;

  @override
  Future<Response<dynamic>> get(String path, {Map<String, dynamic>? query}) {
    return _dio.get<dynamic>(path, queryParameters: query);
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? headers,
  }) =>
      throw UnimplementedError();

  @override
  set locale(String value) => throw UnimplementedError();

  @override
  Future<void> Function() get onSessionLost => throw UnimplementedError();
}

class _FakeBundle implements DailyLawBundleDataSource {
  int reads = 0;

  @override
  Future<List<DailyLawModel>> readCatalogue() async {
    reads++;
    return <DailyLawModel>[_bundled('bundle-a'), _bundled('bundle-b')];
  }
}

DailyLawModel _bundled(String id) {
  return DailyLawModel(
    id: id,
    topic: 'Mehnat huquqi',
    title: 'Sarlavha $id',
    summary: 'Qisqacha',
    steps: const <String>['Bir'],
    source: 'Mehnat kodeksi',
    article: '1-modda',
  );
}

Map<String, dynamic> _article(String id) {
  return <String, dynamic>{
    'id': id,
    'code': 'Labor Code',
    'number': 'Article 89',
    'title': 'Probation is paid work',
    'body': 'Probation time is paid in full. Check the contract terms. '
        'Keep a copy of every request.',
    'topic': 'LABOR',
    'sourceUrl': null,
  };
}

ResponseBody _json(Map<String, dynamic> body, int status) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}

Map<String, dynamic> _pagedList(
  List<Map<String, dynamic>> items, {
  required int page,
  required int pageCount,
}) {
  return <String, dynamic>{
    'items': items,
    'page': page,
    'pageCount': pageCount,
    'total': items.length,
  };
}

int _pageOf(RequestOptions options) {
  return options.queryParameters['page'] as int;
}

void main() {
  late _ScriptedAdapter adapter;
  late _FakeBundle bundle;
  late DailyLawCatalogueDataSourceImpl catalogue;

  void wire(_Handler handler) {
    adapter = _ScriptedAdapter(handler);
    final Dio dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl))
      ..httpClientAdapter = adapter;
    bundle = _FakeBundle();
    catalogue = DailyLawCatalogueDataSourceImpl(
      remote: DailyLawRemoteDataSourceImpl(_ScriptedApiClient(dio)),
      bundle: bundle,
    );
  }

  test('serves the remote corpus and maps a law article', () async {
    wire(
      (RequestOptions options) async => _json(
        _pagedList(
          <Map<String, dynamic>>[_article('law-1')],
          page: 1,
          pageCount: 1,
        ),
        200,
      ),
    );

    final List<DailyLawModel> laws = await catalogue.readCatalogue();

    expect(laws.length, 1);
    expect(bundle.reads, 0);
    final DailyLawModel law = laws.single;
    expect(law.id, 'law-1');
    expect(law.topic, 'Mehnat huquqi');
    expect(law.source, 'Labor Code');
    expect(law.article, 'Article 89');
    expect(law.summary, 'Probation time is paid in full.');
    expect(law.steps, <String>[
      'Check the contract terms.',
      'Keep a copy of every request.',
    ]);
  });

  test('walks every page before answering', () async {
    wire((RequestOptions options) async {
      final int page = _pageOf(options);
      return _json(
        _pagedList(
          <Map<String, dynamic>>[_article('law-$page')],
          page: page,
          pageCount: 3,
        ),
        200,
      );
    });

    final List<DailyLawModel> laws = await catalogue.readCatalogue();

    expect(laws.map((DailyLawModel law) => law.id), <String>[
      'law-1',
      'law-2',
      'law-3',
    ]);
    expect(adapter.calls.length, 3);
  });

  test('falls back to the bundle when the request fails', () async {
    wire(
      (RequestOptions options) async =>
          _json(<String, dynamic>{'error': 'nope'}, 500),
    );

    final List<DailyLawModel> laws = await catalogue.readCatalogue();

    expect(bundle.reads, 1);
    expect(laws.map((DailyLawModel law) => law.id), <String>[
      'bundle-a',
      'bundle-b',
    ]);
  });

  test('falls back to the bundle when the network is unreachable', () async {
    wire(
      (RequestOptions options) async => throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      ),
    );

    final List<DailyLawModel> laws = await catalogue.readCatalogue();

    expect(bundle.reads, 1);
    expect(laws.length, 2);
  });

  test('falls back to the bundle when the corpus comes back empty', () async {
    wire(
      (RequestOptions options) async => _json(
        _pagedList(<Map<String, dynamic>>[], page: 1, pageCount: 1),
        200,
      ),
    );

    final List<DailyLawModel> laws = await catalogue.readCatalogue();

    expect(adapter.calls.length, 1);
    expect(bundle.reads, 1);
    expect(laws.first.id, 'bundle-a');
  });

  test('keeps the corpus for the session instead of refetching', () async {
    wire(
      (RequestOptions options) async => _json(
        _pagedList(
          <Map<String, dynamic>>[_article('law-1')],
          page: 1,
          pageCount: 1,
        ),
        200,
      ),
    );

    final List<DailyLawModel> first = await catalogue.readCatalogue();
    final List<DailyLawModel> second = await catalogue.readCatalogue();

    expect(adapter.calls.length, 1);
    expect(identical(first, second), isTrue);
  });

  test('keeps the fallback corpus for the session as well', () async {
    wire(
      (RequestOptions options) async =>
          _json(<String, dynamic>{'error': 'nope'}, 500),
    );

    await catalogue.readCatalogue();
    await catalogue.readCatalogue();

    expect(adapter.calls.length, 1);
    expect(bundle.reads, 1);
  });
}
