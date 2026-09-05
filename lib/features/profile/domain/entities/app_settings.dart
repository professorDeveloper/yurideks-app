import 'package:equatable/equatable.dart';

enum AppLocale {
  uz('uz'),
  uzCyrl('uz-cyrl'),
  ru('ru'),
  en('en');

  const AppLocale(this.code);

  final String code;

  static AppLocale fromCode(String? code) {
    return AppLocale.values.firstWhere(
      (AppLocale locale) => locale.code == code,
      orElse: () => AppLocale.uz,
    );
  }
}

class AppSettings extends Equatable {
  const AppSettings({this.locale = AppLocale.uz, this.dailyReminder = true});

  final AppLocale locale;
  final bool dailyReminder;

  AppSettings copyWith({AppLocale? locale, bool? dailyReminder}) {
    return AppSettings(
      locale: locale ?? this.locale,
      dailyReminder: dailyReminder ?? this.dailyReminder,
    );
  }

  @override
  List<Object?> get props => <Object?>[locale, dailyReminder];
}
