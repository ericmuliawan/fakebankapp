import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rml_fakebank_app/feature/auth/domain/entities/profile.dart';
import 'package:rml_fakebank_app/feature/auth/domain/entities/user.dart';
import 'package:rml_fakebank_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:rml_fakebank_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:rml_fakebank_app/feature/auth/presentation/pages/auth_page.dart';
import 'package:rml_fakebank_app/model/common/api_error.dart';
import 'package:rml_fakebank_app/model/common/api_result.dart';
import 'package:rml_fakebank_app/uikit/button/primary_button.dart';

class _StubAuthRepository implements IAuthRepository {
  @override
  Future<ApiResult<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    return ApiResult.success(
      AuthSession(
        accessToken: 'token',
        user: User(id: '1', name: 'Test User', email: email),
      ),
    );
  }

  @override
  Future<ApiResult<Profile>> getProfile() async {
    return ApiResult.success(
      const Profile(
        id: 3,
        email: 'eric@rml.co.id',
        balance: 1000000,
        fullName: 'Eric Muliawan',
        accountNumber: '9060539954',
      ),
    );
  }

  @override
  Future<ApiResult<int>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    return ApiResult.success(1);
  }

  @override
  Future<ApiResult<AuthSession>> restoreSession() async {
    return ApiResult.error(const ApiError(code: 401));
  }

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('Auth page renders login mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthPage(bloc: AuthBloc(repository: _StubAuthRepository())),
      ),
    );

    expect(find.text('FakeBank'), findsOneWidget);
    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Create Account'), findsWidgets);
  });

  testWidgets('Auth page switches to register mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthPage(bloc: AuthBloc(repository: _StubAuthRepository())),
      ),
    );

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Full name'), findsOneWidget);
    expect(find.widgetWithText(PrimaryButton, 'Create Account'), findsOneWidget);
  });
}