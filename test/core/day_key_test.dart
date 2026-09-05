import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/utils/day_key.dart';

void main() {
  group('DayKey', () {
    test('formats a day as a zero padded ISO date', () {
      expect(DayKey.of(DateTime(2026, 9, 4)), '2026-09-04');
      expect(DayKey.of(DateTime(2026, 11, 21)), '2026-11-21');
    });

    test('counts consecutive days back from today', () {
      final DateTime today = DateTime(2026, 9, 4);
      final List<String> days = <String>[
        '2026-09-02',
        '2026-09-03',
        '2026-09-04',
      ];
      expect(DayKey.streak(days, today), 3);
    });

    test('stops counting at the first missing day', () {
      final DateTime today = DateTime(2026, 9, 4);
      final List<String> days = <String>[
        '2026-08-30',
        '2026-09-03',
        '2026-09-04',
      ];
      expect(DayKey.streak(days, today), 2);
    });

    test('is zero when today has not been opened', () {
      final DateTime today = DateTime(2026, 9, 4);
      expect(DayKey.streak(<String>['2026-09-03'], today), 0);
    });

    test('ignores the time of day', () {
      final DateTime today = DateTime(2026, 9, 4, 23, 59);
      expect(DayKey.streak(<String>['2026-09-04'], today), 1);
    });

    test('advances the index by one per calendar day', () {
      final int first = DayKey.index(DateTime(2026, 9, 4));
      final int second = DayKey.index(DateTime(2026, 9, 5));
      expect(second - first, 1);
    });
  });
}
