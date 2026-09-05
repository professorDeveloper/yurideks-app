import '../constants/app_strings.dart';

abstract final class Greeting {
  static String forHour(int hour) {
    if (hour < 5) {
      return AppStrings.greetingNight;
    }
    if (hour < 11) {
      return AppStrings.greetingMorning;
    }
    if (hour < 18) {
      return AppStrings.greetingDay;
    }
    return AppStrings.greetingEvening;
  }
}
