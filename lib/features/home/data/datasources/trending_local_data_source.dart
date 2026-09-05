import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/day_key.dart';

abstract interface class TrendingLocalDataSource {
  Future<String> readQuestionOfTheDay(DateTime moment);
}

class TrendingLocalDataSourceImpl implements TrendingLocalDataSource {
  TrendingLocalDataSourceImpl(this._bundle);

  final AssetBundle _bundle;

  List<String>? _cache;

  @override
  Future<String> readQuestionOfTheDay(DateTime moment) async {
    final List<String> questions = _cache ??= await _load();
    return questions[DayKey.index(moment) % questions.length];
  }

  Future<List<String>> _load() async {
    try {
      final String raw = await _bundle.loadString(AppAssets.trendingQuestions);
      final List<String> questions =
          (jsonDecode(raw) as List<dynamic>).cast<String>();
      if (questions.isEmpty) {
        throw const CacheException();
      }
      return questions;
    } on FormatException {
      throw const CacheException();
    }
  }
}
