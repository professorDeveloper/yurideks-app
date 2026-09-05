import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/error/failures.dart';
import 'package:yurideks_app/core/utils/day_key.dart';
import 'package:yurideks_app/features/daily_law/data/datasources/daily_law_catalogue_data_source.dart';
import 'package:yurideks_app/features/daily_law/data/datasources/daily_law_local_data_source.dart';
import 'package:yurideks_app/features/daily_law/data/models/daily_law_model.dart';
import 'package:yurideks_app/features/daily_law/data/repositories/daily_law_repository_impl.dart';
import 'package:yurideks_app/features/daily_law/domain/entities/daily_box.dart';
import 'package:yurideks_app/features/daily_law/domain/entities/law_collection.dart';

class _FakeCatalogue implements DailyLawCatalogueDataSource {
  _FakeCatalogue(this.laws);

  final List<DailyLawModel> laws;

  @override
  Future<List<DailyLawModel>> readCatalogue() async => laws;
}

class _FakeLocal implements DailyLawLocalDataSource {
  final List<String> collected = <String>[];
  final List<String> opened = <String>[];

  @override
  Future<void> addCollectedId(String id) async {
    if (!collected.contains(id)) {
      collected.add(id);
    }
  }

  @override
  Future<void> addOpenedDay(String day) async {
    if (!opened.contains(day)) {
      opened.add(day);
    }
  }

  @override
  Future<List<String>> readCollectedIds() async => collected;

  @override
  Future<List<String>> readOpenedDays() async => opened;
}

DailyLawModel _law(String id) {
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

void main() {
  late _FakeCatalogue catalogue;
  late _FakeLocal local;
  late DailyLawRepositoryImpl repository;

  setUp(() {
    catalogue =
        _FakeCatalogue(<DailyLawModel>[_law('a'), _law('b'), _law('c')]);
    local = _FakeLocal();
    repository = DailyLawRepositoryImpl(catalogue, local);
  });

  Future<DailyBox> box(Future<Either<Failure, DailyBox>> call) async {
    final Either<Failure, DailyBox> result = await call;
    return result.fold(
      (Failure failure) => throw StateError('unexpected $failure'),
      (DailyBox value) => value,
    );
  }

  test('today is closed before it has been opened', () async {
    final DailyBox today = await box(repository.readTodayBox());
    expect(today.isOpened, isFalse);
    expect(today.collectedCount, 0);
    expect(today.streak, 0);
    expect(today.catalogueSize, 3);
  });

  test('opening marks today, collects the law and starts the streak', () async {
    final DailyBox opened = await box(repository.openTodayBox());
    expect(opened.isOpened, isTrue);
    expect(opened.collectedCount, 1);
    expect(opened.streak, 1);
    expect(local.opened, <String>[DayKey.of(DateTime.now())]);
  });

  test('opening twice on the same day collects only once', () async {
    await repository.openTodayBox();
    final DailyBox second = await box(repository.openTodayBox());
    expect(second.collectedCount, 1);
    expect(local.opened.length, 1);
  });

  test('the same law is served for the whole day', () async {
    final DailyBox first = await box(repository.readTodayBox());
    final DailyBox second = await box(repository.readTodayBox());
    expect(first.law.id, second.law.id);
  });

  test('the next box is due at tomorrow midnight', () async {
    final DailyBox today = await box(repository.readTodayBox());
    final DateTime now = DateTime.now();
    expect(today.opensAt, DateTime(now.year, now.month, now.day + 1));
  });

  test('the collection holds only the laws that were opened', () async {
    await repository.openTodayBox();
    final Either<Failure, LawCollection> result =
        await repository.readCollection();
    final LawCollection collection = result.getOrElse(
      () => throw StateError('expected a collection'),
    );
    expect(collection.laws.length, 1);
    expect(collection.catalogueSize, 3);
    expect(local.collected.contains(collection.laws.single.id), isTrue);
  });
}
