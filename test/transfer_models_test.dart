import 'package:flutter_test/flutter_test.dart';

import 'package:rml_fakebank_app/feature/transfer/data/models/transfer_request.dart';
import 'package:rml_fakebank_app/feature/transfer/data/models/transfer_response.dart';

void main() {
  group('TransferRequest', () {
    test('serializes to the documented body', () {
      const request = TransferRequest(
        recipientAccount: '8373170952',
        amount: 50000,
        notes: 'Lunch',
      );
      expect(request.toJson(), {
        'recipient_account': '8373170952',
        'amount': 50000,
        'notes': 'Lunch',
      });
    });
  });

  group('TransferResponse', () {
    test('parses a real transfer success payload', () {
      const json = {
        'success': true,
        'message': 'Transfer successful',
        'data': {'reference_no': 'TRX2026465068'},
      };
      final response = TransferResponse.fromJson(json);
      expect(response.referenceNo, 'TRX2026465068');
    });

    test('parses an error payload without crashing', () {
      final response = TransferResponse.fromJson(const {
        'success': false,
        'message': 'Insufficient balance',
        'data': null,
      });
      expect(response.referenceNo, isEmpty);
    });
  });
}