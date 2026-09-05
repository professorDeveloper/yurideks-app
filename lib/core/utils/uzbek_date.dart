abstract final class UzbekDate {
  static const List<String> _months = <String>[
    'yanvar',
    'fevral',
    'mart',
    'aprel',
    'may',
    'iyun',
    'iyul',
    'avgust',
    'sentabr',
    'oktabr',
    'noyabr',
    'dekabr',
  ];

  static const List<String> _weekdays = <String>[
    'dushanba',
    'seshanba',
    'chorshanba',
    'payshanba',
    'juma',
    'shanba',
    'yakshanba',
  ];

  static String long(DateTime moment) {
    return '${moment.day}-${_months[moment.month - 1]}, '
        '${_weekdays[moment.weekday - 1]}';
  }
}
