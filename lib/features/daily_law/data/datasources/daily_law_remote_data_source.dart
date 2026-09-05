import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/daily_law_model.dart';

abstract interface class DailyLawRemoteDataSource {
  Future<List<DailyLawModel>> readCatalogue();
}

class DailyLawRemoteDataSourceImpl implements DailyLawRemoteDataSource {
  const DailyLawRemoteDataSourceImpl(this._client);

  static const String _lawsPath = '/api/laws';
  static const String _pageQuery = 'page';
  static const int _firstPage = 1;
  static const int _maxPages = 20;

  final ApiClient _client;

  @override
  Future<List<DailyLawModel>> readCatalogue() async {
    final List<DailyLawModel> laws = <DailyLawModel>[];
    int page = _firstPage;
    int pageCount = _firstPage;

    while (page <= pageCount && page < _firstPage + _maxPages) {
      final _LawPage current = await _readPage(page);
      if (current.laws.isEmpty) {
        break;
      }
      laws.addAll(current.laws);
      pageCount = current.pageCount;
      page++;
    }

    return List<DailyLawModel>.unmodifiable(laws);
  }

  Future<_LawPage> _readPage(int page) async {
    try {
      final Response<dynamic> response = await _client.get(
        _lawsPath,
        query: <String, dynamic>{_pageQuery: page},
      );
      return _LawPage.fromResponse(response.data);
    } on DioException catch (error) {
      throw _transportException(error);
    } on FormatException {
      throw const ServerException();
    } on TypeError {
      throw const ServerException();
    }
  }

  Exception _transportException(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        const NetworkException(),
      _ => const ServerException(),
    };
  }
}

class _LawPage {
  const _LawPage({required this.laws, required this.pageCount});

  factory _LawPage.fromResponse(Object? body) {
    if (body is! Map<String, dynamic>) {
      throw const ServerException();
    }
    final Object? items = body['items'];
    if (items is! List<dynamic>) {
      throw const ServerException();
    }
    return _LawPage(
      laws: items
          .whereType<Map<String, dynamic>>()
          .map(DailyLawModel.fromLawArticleJson)
          .toList(growable: false),
      pageCount: _pageCountOf(body['pageCount']),
    );
  }

  static int _pageCountOf(Object? raw) {
    return raw is int && raw > 0 ? raw : 1;
  }

  final List<DailyLawModel> laws;
  final int pageCount;
}
