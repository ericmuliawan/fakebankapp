import 'dart:io';

import 'package:dio/dio.dart';

import 'package:rml_fakebank_app/model/common/api_error.dart';
import 'package:rml_fakebank_app/model/common/api_result.dart';

extension ApiHandler on Response<dynamic> {
  ApiResult<T> parse<T>({T Function(Map<String, dynamic> data)? mapper}) {
    if (statusCode != null && statusCode! >= 200 && statusCode! < 300) {
      if (data is Map<String, dynamic>) {
        final mapped = mapper?.call(data);
        if (mapped != null) return ApiResult.success(mapped);
        return ApiResult.success(data as T);
      }
      return ApiResult.success(data as T);
    } else {
      final message = data is Map ? (data as Map)['message']?.toString() : null;
      return ApiResult.error(
        ApiError(code: statusCode, message: message),
      );
    }
  }
}

extension ApiErrorHandler on DioException {
  ApiResult<T> toApiResult<T>() {
    final response = this.response;
    if (response != null) {
      final data = response.data;
      final message = data is Map ? data['message']?.toString() : null;
      return ApiResult.error(
        ApiError(code: response.statusCode, message: message),
      );
    }

    final isNetworkError = type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.connectionError ||
        error is SocketException;
    if (isNetworkError) {
      return ApiResult.error(
        const ApiError(
          code: ApiErrorCode.networkError,
          message: 'No internet connection. Please try again.',
        ),
      );
    }

    return ApiResult.error(
      ApiError(
        code: ApiErrorCode.unknownError,
        message: message ?? 'Something went wrong. Please try again.',
      ),
    );
  }
}

abstract final class ApiErrorCode {
  static const int networkError = -1;
  static const int unknownError = -2;
}