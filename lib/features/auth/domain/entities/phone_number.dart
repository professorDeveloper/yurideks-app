import 'package:equatable/equatable.dart';

class PhoneNumber extends Equatable {
  const PhoneNumber(this.nationalDigits);

  factory PhoneNumber.fromE164(String value) {
    final String digits = value.replaceAll(RegExp(r'\D'), '');
    return PhoneNumber(
      digits.length > requiredLength
          ? digits.substring(digits.length - requiredLength)
          : digits,
    );
  }

  static const String dialCode = '+998';
  static const int requiredLength = 9;

  final String nationalDigits;

  bool get isComplete => nationalDigits.length == requiredLength;

  String get e164 => '$dialCode$nationalDigits';

  String get formatted {
    if (nationalDigits.length < requiredLength) {
      return '$dialCode $nationalDigits';
    }
    final String a = nationalDigits.substring(0, 2);
    final String b = nationalDigits.substring(2, 5);
    final String c = nationalDigits.substring(5, 7);
    final String d = nationalDigits.substring(7, 9);
    return '$dialCode $a $b $c $d';
  }

  @override
  List<Object?> get props => <Object?>[nationalDigits];
}
