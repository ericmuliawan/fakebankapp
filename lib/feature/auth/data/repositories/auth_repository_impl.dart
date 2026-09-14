import 'package:rml_fakebank_app/common/local_storage_provider.dart';
import 'package:rml_fakebank_app/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/login_request.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/login_response.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/profile_response.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/register_request.dart';
import 'package:rml_fakebank_app/feature/auth/data/models/register_response.dart';
import 'package:rml_fakebank_app/feature/auth/domain/entities/profile.dart';
import 'package:rml_fakebank_app/feature/auth/domain/entities/user.dart';
import 'package:rml_fakebank_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:rml_fakebank_app/model/common/api_error.dart';
import 'package:rml_fakebank_app/model/common/api_result.dart';

class AuthRepository implements IAuthRepository {
  AuthRepository({
    required IAuthRemoteDataSource remoteDataSource,
    required ILocalStorageProvider localStorageProvider,
  })  : _remoteDataSource = remoteDataSource,
        _localStorageProvider = localStorageProvider;

  final IAuthRemoteDataSource _remoteDataSource;
  final ILocalStorageProvider _localStorageProvider;

  @override
  Future<ApiResult<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      LoginRequest(email: email, password: password),
    );

    switch (result) {
      case Success<LoginResponse>(:final response):
        final session = AuthSession(
          accessToken: response.accessToken,
          tokenType: response.tokenType,
          expiresIn: response.expiresIn,
          user: User(id: '', name: '', email: email),
        );
        await _persistSession(session);
        return ApiResult.success(session);
      case Error<LoginResponse>(:final error):
        return ApiResult.error(error);
    }
  }

  @override
  Future<ApiResult<int>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.register(
      RegisterRequest(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );

    switch (result) {
      case Success<RegisterResponse>(:final response):
        return ApiResult.success(response.userId);
      case Error<RegisterResponse>(:final error):
        return ApiResult.error(error);
    }
  }

  @override
  Future<ApiResult<Profile>> getProfile() async {
    final result = await _remoteDataSource.getProfile();

    switch (result) {
      case Success<ProfileResponse>(:final response):
        return ApiResult.success(
          Profile(
            id: response.id,
            email: response.email,
            balance: response.balance,
            fullName: response.fullName,
            accountNumber: response.accountNumber,
          ),
        );
      case Error<ProfileResponse>(:final error):
        return ApiResult.error(error);
    }
  }

  @override
  Future<ApiResult<AuthSession>> restoreSession() async {
    if (!_localStorageProvider.getUserLogin()) {
      return ApiResult.error(_unauthenticated);
    }

    final token = _localStorageProvider.getAuthToken();
    final email = _localStorageProvider.getUserEmail();
    if (token.isEmpty || email.isEmpty) {
      await _localStorageProvider.deleteAuthToken();
      return ApiResult.error(_unauthenticated);
    }

    final session = AuthSession(
      accessToken: token,
      user: User(id: '', name: '', email: email),
    );
    return ApiResult.success(session);
  }

  @override
  Future<void> logout() async {
    await _localStorageProvider.deleteAuthToken();
  }

  Future<void> _persistSession(AuthSession session) async {
    await _localStorageProvider.setAuthToken(session.accessToken);
    await _localStorageProvider.setUserLogin(true);
    await _localStorageProvider.setUserEmail(session.user?.email ?? '');
  }

  static const _unauthenticated = ApiError(code: 401, message: 'Unauthenticated');
}