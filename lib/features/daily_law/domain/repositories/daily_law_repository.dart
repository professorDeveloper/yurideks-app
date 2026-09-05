import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/daily_box.dart';
import '../entities/law_collection.dart';

abstract interface class DailyLawRepository {
  Future<Either<Failure, DailyBox>> readTodayBox();

  Future<Either<Failure, DailyBox>> openTodayBox();

  Future<Either<Failure, LawCollection>> readCollection();
}
