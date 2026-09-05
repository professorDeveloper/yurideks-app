import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract interface class DailyLawLocalDataSource {
  Future<List<String>> readCollectedIds();

  Future<void> addCollectedId(String id);

  Future<List<String>> readOpenedDays();

  Future<void> addOpenedDay(String day);
}

class DailyLawLocalDataSourceImpl implements DailyLawLocalDataSource {
  const DailyLawLocalDataSourceImpl(this._preferences);

  static const String _collectedKey = 'dailyLaw.collected';
  static const String _openedDaysKey = 'dailyLaw.openedDays';

  final SharedPreferences _preferences;

  @override
  Future<List<String>> readCollectedIds() async {
    return _preferences.getStringList(_collectedKey) ?? <String>[];
  }

  @override
  Future<void> addCollectedId(String id) async {
    final List<String> current = await readCollectedIds();
    if (current.contains(id)) {
      return;
    }
    final bool saved = await _preferences.setStringList(
      _collectedKey,
      <String>[...current, id],
    );
    if (!saved) {
      throw const CacheException();
    }
  }

  @override
  Future<List<String>> readOpenedDays() async {
    return _preferences.getStringList(_openedDaysKey) ?? <String>[];
  }

  @override
  Future<void> addOpenedDay(String day) async {
    final List<String> current = await readOpenedDays();
    if (current.contains(day)) {
      return;
    }
    final bool saved = await _preferences.setStringList(
      _openedDaysKey,
      <String>[...current, day],
    );
    if (!saved) {
      throw const CacheException();
    }
  }
}
