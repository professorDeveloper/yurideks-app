import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/app_settings.dart';

abstract interface class SettingsLocalDataSource {
  Future<AppSettings> read();

  Future<void> write(AppSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl(this._preferences);

  static const String _localeKey = 'settings.locale';
  static const String _reminderKey = 'settings.dailyReminder';

  final SharedPreferences _preferences;

  @override
  Future<AppSettings> read() async {
    return AppSettings(
      locale: AppLocale.fromCode(_preferences.getString(_localeKey)),
      dailyReminder: _preferences.getBool(_reminderKey) ?? true,
    );
  }

  @override
  Future<void> write(AppSettings settings) async {
    final bool locale = await _preferences.setString(
      _localeKey,
      settings.locale.code,
    );
    final bool reminder = await _preferences.setBool(
      _reminderKey,
      settings.dailyReminder,
    );
    if (!locale || !reminder) {
      throw const CacheException();
    }
  }
}
