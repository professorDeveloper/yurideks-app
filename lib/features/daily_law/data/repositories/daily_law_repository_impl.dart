import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/day_key.dart';
import '../../domain/entities/daily_box.dart';
import '../../domain/entities/law_collection.dart';
import '../../domain/repositories/daily_law_repository.dart';
import '../datasources/daily_law_catalogue_data_source.dart';
import '../datasources/daily_law_local_data_source.dart';
import '../models/daily_law_model.dart';

class DailyLawRepositoryImpl implements DailyLawRepository {
  const DailyLawRepositoryImpl(this._catalogue, this._local);

  final DailyLawCatalogueDataSource _catalogue;
  final DailyLawLocalDataSource _local;

  @override
  Future<Either<Failure, DailyBox>> readTodayBox() {
    return _guard(() async => _buildBox(opening: false));
  }

  @override
  Future<Either<Failure, DailyBox>> openTodayBox() {
    return _guard(() async => _buildBox(opening: true));
  }

  @override
  Future<Either<Failure, LawCollection>> readCollection() {
    return _guard(() async {
      final List<DailyLawModel> laws = await _catalogue.readCatalogue();
      final List<String> collected = await _local.readCollectedIds();
      return LawCollection(
        laws: laws
            .where((DailyLawModel law) => collected.contains(law.id))
            .toList(growable: false),
        catalogueSize: laws.length,
      );
    });
  }

  Future<DailyBox> _buildBox({required bool opening}) async {
    final List<DailyLawModel> laws = await _catalogue.readCatalogue();
    final DateTime now = DateTime.now();
    final String today = DayKey.of(now);
    final DailyLawModel law = laws[DayKey.index(now) % laws.length];

    if (opening) {
      await _local.addOpenedDay(today);
      await _local.addCollectedId(law.id);
    }

    final List<String> openedDays = await _local.readOpenedDays();
    final List<String> collected = await _local.readCollectedIds();

    return DailyBox(
      law: law,
      isOpened: openedDays.contains(today),
      collectedCount: collected.length,
      catalogueSize: laws.length,
      streak: DayKey.streak(openedDays, now),
      opensAt: DateTime(now.year, now.month, now.day).add(
        const Duration(days: 1),
      ),
    );
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right<Failure, T>(await action());
    } on CacheException {
      return const Left<Failure, Never>(CacheFailure());
    } catch (_) {
      return const Left<Failure, Never>(UnknownFailure());
    }
  }
}
