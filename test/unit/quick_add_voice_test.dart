import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/quick_add/presentation/widgets/quick_add_voice_input.dart';

void main() {
  group('parseVoiceExpense', () {
    test('extracts digit amount and merchant', () {
      final (paise, merchant) = parseVoiceExpense('200 rupees for lunch');
      expect(paise, 20000);
      expect(merchant, 'Lunch');
    });

    test('extracts word amount', () {
      final (paise, _) = parseVoiceExpense('spent five hundred on petrol');
      expect(paise, 50000);
    });

    test('returns zero when no amount', () {
      final (paise, merchant) = parseVoiceExpense('coffee');
      expect(paise, 0);
      expect(merchant, 'Coffee');
    });
  });
}
