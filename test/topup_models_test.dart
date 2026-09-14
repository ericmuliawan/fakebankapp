import 'package:flutter_test/flutter_test.dart';

import 'package:rml_fakebank_app/feature/topup/data/models/topup_request.dart';
import 'package:rml_fakebank_app/feature/topup/data/models/topup_response.dart';

void main() {
  group('TopUpRequest', () {
    test('serializes to the documented body', () {
      const request = TopUpRequest(amount: 100000);
      expect(request.toJson(), {'amount': 100000});
    });
  });

  group('TopUpResponse', () {
    test('parses a real top up success payload', () {
      final response = TopUpResponse.fromJson(const {
        'success': true,
        'message': 'Top up successful',
        'data': {'reference_no': 'TP2026470714'},
      });
      expect(response.referenceNo, 'TP2026470714');
    });

    test('parses an error payload without crashing', () {
      final response = TopUpResponse.fromJson(const {
        'success': false,
        'message': 'Validation Error',
        'data': {'amount': 'Amount must be greater than zero'},
      });
      expect(response.referenceNo, isEmpty);
    });
  });
}