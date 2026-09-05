import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/utils/phone_formatter.dart';

void main() {
  const TextEditingValue empty = TextEditingValue.empty;
  final UzbekPhoneFormatter formatter = UzbekPhoneFormatter();

  TextEditingValue format(String input) =>
      formatter.formatEditUpdate(empty, TextEditingValue(text: input));

  group('UzbekPhoneFormatter', () {
    test('groups digits as 2 3 2 2', () {
      expect(format('901234567').text, '90 123 45 67');
    });

    test('drops non digit characters', () {
      expect(format('90-123 45.67').text, '90 123 45 67');
    });

    test('caps the input at nine digits', () {
      expect(format('9012345678888').text, '90 123 45 67');
    });

    test('formats partial input without trailing separator', () {
      expect(format('9012').text, '90 12');
    });

    test('keeps the caret at the end', () {
      final TextEditingValue value = format('901');
      expect(value.selection.baseOffset, value.text.length);
    });
  });
}
