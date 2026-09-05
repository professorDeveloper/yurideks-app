import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract interface class IntroLocalDataSource {
  Future<bool> readSeen();

  Future<void> writeSeen();
}

class IntroLocalDataSourceImpl implements IntroLocalDataSource {
  const IntroLocalDataSourceImpl(this._preferences);

  static const String _seenKey = 'intro.seen';

  final SharedPreferences _preferences;

  @override
  Future<bool> readSeen() async {
    return _preferences.getBool(_seenKey) ?? false;
  }

  @override
  Future<void> writeSeen() async {
    final bool saved = await _preferences.setBool(_seenKey, true);
    if (!saved) {
      throw const CacheException();
    }
  }
}
