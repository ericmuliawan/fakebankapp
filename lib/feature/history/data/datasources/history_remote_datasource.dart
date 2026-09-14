import 'package:dio/dio.dart';

import '../../../../model/common/api_error.dart';
import '../../../../model/common/api_result.dart';
import '../../../../common/network/network_response_handler.dart';
import '../models/transaction_response.dart';

abstract interface class IHistoryRemoteDataSource {
  Future<ApiResult<List<TransactionResponse>>> getHistory({int? limit});
}

class HistoryRemoteDataSource implements IHistoryRemoteDataSource {
  HistoryRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  static const _historyPath = '/history';

  @override
  Future<ApiResult<List<TransactionResponse>>> getHistory({int? limit}) async {
    try {
      final response = await _dio.get<dynamic>(
        _historyPath,
        queryParameters: {if (limit != null) 'limit': limit},
      );
      final payload = response.data;
      final statusCode = response.statusCode;

      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        final items = payload is Map ? payload['data'] : null;
        if (items is List) {
          final parsed = items
              .map(
                (e) => TransactionResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList();
          return ApiResult.success(parsed);
        }
      }

      final message = payload is Map ? payload['message']?.toString() : null;
      return ApiResult.error(ApiError(code: statusCode, message: message));
    } on DioException catch (error) {
      return error.toApiResult<List<TransactionResponse>>();
    }
  }
}