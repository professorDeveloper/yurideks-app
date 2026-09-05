abstract final class DayKey {
  static String of(DateTime moment) {
    final String month = moment.month.toString().padLeft(2, '0');
    final String day = moment.day.toString().padLeft(2, '0');
    return '${moment.year}-$month-$day';
  }

  static int streak(List<String> days, DateTime today) {
    final Set<String> seen = days.toSet();
    int count = 0;
    DateTime cursor = DateTime(today.year, today.month, today.day);
    while (seen.contains(of(cursor))) {
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return count;
  }

  static int index(DateTime moment) {
    return DateTime(moment.year, moment.month, moment.day)
        .difference(DateTime(2020))
        .inDays;
  }
}
