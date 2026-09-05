import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/error/exceptions.dart';
import '../models/daily_law_model.dart';

abstract interface class DailyLawBundleDataSource {
  Future<List<DailyLawModel>> readCatalogue();
}

class DailyLawBundleDataSourceImpl implements DailyLawBundleDataSource {
  DailyLawBundleDataSourceImpl(this._bundle);

  final AssetBundle _bundle;

  List<DailyLawModel>? _cache;

  @override
  Future<List<DailyLawModel>> readCatalogue() async {
    final List<DailyLawModel>? cached = _cache;
    if (cached != null) {
      return cached;
    }
    try {
      final String raw = await _bundle.loadString(AppAssets.dailyLaws);
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      final List<DailyLawModel> laws = decoded
          .map(
            (dynamic item) =>
                DailyLawModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false);
      if (laws.isEmpty) {
        throw const CacheException();
      }
      _cache = laws;
      return laws;
    } on FormatException {
      throw const CacheException();
    }
  }
}
