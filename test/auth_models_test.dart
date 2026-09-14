import 'package:flutter_test/flutter_test.dart';

import 'package:rml_fakebank_app/common/utils/currency_formatter.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/login_request.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/login_response.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/profile_response.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/register_request.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/register_response.dart';

void main() {
  group('LoginRequest', () {
    test('serializes to the documented body', () {
      const request = LoginRequest(
        email: 'dimas@rml.co.id',
        password: 'Raditya123',
      );
      expect(request.toJson(), {
        'email': 'dimas@rml.co.id',
        'password': 'Raditya123',
      });
    });
  });

  group('LoginResponse', () {
    test('parses a real login success payload', () {
      const json = {
        'success': true,
        'message': 'Login successful',
        'data': {
          'access_token': 'eyJhbGciOiJIUzI1NiJ9.xxx',
          'token_type': 'Bearer',
          'expires_in': 3600,
        },
      };
      final response = LoginResponse.fromJson(json);
      expect(response.accessToken, 'eyJhbGciOiJIUzI1NiJ9.xxx');
      expect(response.tokenType, 'Bearer');
      expect(response.expiresIn, 3600);
    });

    test('parses a missing-token edge case without crashing', () {
      final response = LoginResponse.fromJson(const {
        'success': false,
        'message': 'Invalid email or password',
        'data': null,
      });
      expect(response.accessToken, isEmpty);
      expect(response.tokenType, isNull);
      expect(response.expiresIn, isNull);
    });
  });

  group('RegisterRequest', () {
    test('serializes to the documented body', () {
      const request = RegisterRequest(
        fullName: 'Fahrul Soleh',
        email: 'fahrul@rml.co.id',
        password: 'Raditya123',
      );
      expect(request.toJson(), {
        'full_name': 'Fahrul Soleh',
        'email': 'fahrul@rml.co.id',
        'password': 'Raditya123',
      });
    });
  });

  group('RegisterResponse', () {
    test('parses a real register success payload', () {
      const json = {
        'success': true,
        'message': 'Registration successful',
        'data': {'user_id': 4},
      };
      final response = RegisterResponse.fromJson(json);
      expect(response.userId, 4);
    });
  });

  group('ProfileResponse', () {
    test('parses a real profile payload', () {
      const json = {
        'success': true,
        'message': 'Success',
        'data': {
          'id': 3,
          'email': 'eric@rml.co.id',
          'balance': 1000000.00,
          'full_name': 'Eric Muliawan',
          'account_number': '9060539954',
        },
      };
      final response = ProfileResponse.fromJson(json);
      expect(response.id, 3);
      expect(response.email, 'eric@rml.co.id');
      expect(response.balance, 1000000.00);
      expect(response.fullName, 'Eric Muliawan');
      expect(response.accountNumber, '9060539954');
    });
  });

  group('CurrencyFormatter', () {
    test('formats Indonesian Rupiah', () {
      expect(
        CurrencyFormatter.idr(1000000),
        'Rp 1.000.000',
      );
      expect(
        CurrencyFormatter.idr(25000.50),
        'Rp 25.000,50',
      );
      expect(CurrencyFormatter.idr(0), 'Rp 0');
    });
  });
}