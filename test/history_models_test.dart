import 'package:flutter_test/flutter_test.dart';

import 'package:rml_fakebank_app/feature/history/data/models/transaction_response.dart';

void main() {
  group('TransactionResponse', () {
    test('parses a real history payload', () {
      final transaction = TransactionResponse.fromJson(const {
        'amount': 10000.00,
        'transaction_type': 'TRANSFER',
        'transaction_date': '2026-09-14T06:05:19.324853Z',
      });

      expect(transaction.amount, 10000.00);
      expect(transaction.transactionType, 'TRANSFER');
      expect(
        transaction.transactionDate,
        DateTime.parse('2026-09-14T06:05:19.324853Z'),
      );
      expect(transaction.toEntity().isTransfer, isTrue);
    });

    test('falls back safely for a malformed payload', () {
      final transaction = TransactionResponse.fromJson(const {});
      expect(transaction.amount, 0);
      expect(transaction.transactionType, isEmpty);
    });
  });
}