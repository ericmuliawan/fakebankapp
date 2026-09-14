import 'package:rml_fakebank_app/model/common/api_result.dart';

import '../entities/profile.dart';
import '../entities/user.dart';

abstract interface class IAuthRepository {
  Future<ApiResult<AuthSession>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<int>> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<ApiResult<Profile>> getProfile();

  Future<ApiResult<AuthSession>> restoreSession();

  Future<void> logout();
}