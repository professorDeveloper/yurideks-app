import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/error/exceptions.dart';
import 'package:yurideks_app/core/error/failures.dart';
import 'package:yurideks_app/core/network/api_client.dart';
import 'package:yurideks_app/features/profile/data/datasources/settings_local_data_source.dart';
import 'package:yurideks_app/features/profile/data/repositories/settings_repository_impl.dart';
import 'package:yurideks_app/features/profile/domain/entities/app_settings.dart';

class _FakeLocal implements SettingsLocalDataSource {
  _FakeLocal([this.stored = const AppSettings(), this.failOnWrite = false]);

  AppSettings stored;
  final bool failOnWrite;

  @override
  Future<AppSettings> read() async => stored;

  @override
  Future<void> write(AppSettings settings) async {
    if (failOnWrite) {
      throw const CacheException();
    }
    stored = settings;
  }
}

class _RecordingClient implements ApiClient {
  final List<String> locales = <String>[];

  @override
  set locale(String value) => locales.add(value);

  @override
  Future<Response<dynamic>> get(String path, {Map<String, dynamic>? query}) =>
      throw UnimplementedError();

  @override
  Future<Response<dynamic>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? headers,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> Function() get onSessionLost => throw UnimplementedError();
}

void main() {
  test('reading settings pushes the locale to the api client', () async {
    final _RecordingClient client = _RecordingClient();
    final SettingsRepositoryImpl repository = SettingsRepositoryImpl(
      _FakeLocal(const AppSettings(locale: AppLocale.ru)),
      client,
    );

    final Either<Failure, AppSettings> result = await repository.read();

    expect(result.getOrElse(() => const AppSettings()).locale, AppLocale.ru);
    expect(client.locales, <String>['ru']);
  });

  test('saving a new locale persists it and updates the api client', () async {
    final _RecordingClient client = _RecordingClient();
    final _FakeLocal local = _FakeLocal();
    final SettingsRepositoryImpl repository = SettingsRepositoryImpl(
      local,
      client,
    );

    await repository.save(const AppSettings(locale: AppLocale.uzCyrl));

    expect(local.stored.locale, AppLocale.uzCyrl);
    expect(client.locales, <String>['uz-cyrl']);
  });

  test('a failed write reports a cache failure', () async {
    final SettingsRepositoryImpl repository = SettingsRepositoryImpl(
      _FakeLocal(const AppSettings(), true),
      _RecordingClient(),
    );

    final Either<Failure, AppSettings> result = await repository.save(
      const AppSettings(locale: AppLocale.en),
    );

    expect(result.fold((Failure f) => f, (_) => null), isA<CacheFailure>());
  });

  test('an unknown stored code falls back to Uzbek', () {
    expect(AppLocale.fromCode('klingon'), AppLocale.uz);
    expect(AppLocale.fromCode(null), AppLocale.uz);
    expect(AppLocale.fromCode('uz-cyrl'), AppLocale.uzCyrl);
  });
}
