import 'package:flutter/services.dart';

class UzbekPhoneFormatter extends TextInputFormatter {
  static const int digitCount = 9;
  static const List<int> _groups = <int>[2, 3, 2, 2];

  static String digitsOf(String source) {
    final String digits = source.replaceAll(RegExp(r'\D'), '');
    return digits.length > digitCount
        ? digits.substring(0, digitCount)
        : digits;
  }

  static String format(String source) {
    final String digits = digitsOf(source);
    final StringBuffer buffer = StringBuffer();
    int consumed = 0;
    for (final int size in _groups) {
      if (consumed >= digits.length) {
        break;
      }
      if (consumed > 0) {
        buffer.write(' ');
      }
      final int end =
          consumed + size < digits.length ? consumed + size : digits.length;
      buffer.write(digits.substring(consumed, end));
      consumed = end;
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String formatted = format(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
