import 'package:equatable/equatable.dart';

import 'daily_law.dart';

class DailyBox extends Equatable {
  const DailyBox({
    required this.law,
    required this.isOpened,
    required this.collectedCount,
    required this.catalogueSize,
    required this.streak,
    required this.opensAt,
  });

  final DailyLaw law;
  final bool isOpened;
  final int collectedCount;
  final int catalogueSize;
  final int streak;
  final DateTime opensAt;

  DailyBox copyWith({bool? isOpened, int? collectedCount}) {
    return DailyBox(
      law: law,
      isOpened: isOpened ?? this.isOpened,
      collectedCount: collectedCount ?? this.collectedCount,
      catalogueSize: catalogueSize,
      streak: streak,
      opensAt: opensAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        law,
        isOpened,
        collectedCount,
        catalogueSize,
        streak,
        opensAt,
      ];
}
