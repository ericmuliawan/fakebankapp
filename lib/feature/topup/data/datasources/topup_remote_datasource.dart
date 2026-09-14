import 'package:dio/dio.dart';

import '../../../../model/common/api_result.dart';
import '../../../../common/network/network_response_handler.dart';
import '../models/topup_request.dart';
import '../models/topup_response.dart';

abstract interface class ITopUpRemoteDataSource {
  Future<ApiResult<TopUpResponse>> topUp(int amount);
}

class TopUpRemoteDataSource implements ITopUpRemoteDataSource {
  TopUpRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  static const _topUpPath = '/topup';

  @override
  Future<ApiResult<TopUpResponse>> topUp(int amount) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _topUpPath,
        data: TopUpRequest(amount: amount).toJson(),
      );
      return response.parse(mapper: (data) => TopUpResponse.fromJson(data));
    } on DioException catch (error) {
      return error.toApiResult<TopUpResponse>();
    }
  }
}
