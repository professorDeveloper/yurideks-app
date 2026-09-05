import 'package:equatable/equatable.dart';

import 'daily_law.dart';

class LawCollection extends Equatable {
  const LawCollection({required this.laws, required this.catalogueSize});

  final List<DailyLaw> laws;
  final int catalogueSize;

  @override
  List<Object?> get props => <Object?>[laws, catalogueSize];
}
