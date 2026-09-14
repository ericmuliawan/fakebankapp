import 'package:dio/dio.dart';

import 'package:rml_fakebank_app/common/network/network_response_handler.dart';
import 'package:rml_fakebank_app/model/common/api_result.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/profile_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';

abstract interface class IAuthRemoteDataSource {
  Future<ApiResult<LoginResponse>> login(LoginRequest request);

  Future<ApiResult<RegisterResponse>> register(RegisterRequest request);

  Future<ApiResult<ProfileResponse>> getProfile();
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  static const _loginPath = '/auth/login';
  static const _registerPath = '/auth/register';
  static const _profilePath = '/profile';

  @override
  Future<ApiResult<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _loginPath,
        data: request.toJson(),
      );
      return response.parse(
        mapper: (data) => LoginResponse.fromJson(data),
      );
    } on DioException catch (error) {
      return error.toApiResult<LoginResponse>();
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _registerPath,
        data: request.toJson(),
      );
      return response.parse(
        mapper: (data) => RegisterResponse.fromJson(data),
      );
    } on DioException catch (error) {
      return error.toApiResult<RegisterResponse>();
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> getProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(_profilePath);
      return response.parse(
        mapper: (data) => ProfileResponse.fromJson(data),
      );
    } on DioException catch (error) {
      return error.toApiResult<ProfileResponse>();
    }
  }
}