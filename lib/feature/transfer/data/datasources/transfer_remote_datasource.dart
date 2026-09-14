import 'package:dio/dio.dart';

import 'package:rml_fakebank_app/common/network/network_response_handler.dart';
import 'package:rml_fakebank_app/model/common/api_result.dart';

import '../models/transfer_request.dart';
import '../models/transfer_response.dart';

abstract interface class ITransferRemoteDataSource {
  Future<ApiResult<TransferResponse>> transfer(TransferRequest request);
}

class TransferRemoteDataSource implements ITransferRemoteDataSource {
  TransferRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  static const _transferPath = '/transfer';

  @override
  Future<ApiResult<TransferResponse>> transfer(TransferRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _transferPath,
        data: request.toJson(),
      );
      return response.parse(
        mapper: (data) => TransferResponse.fromJson(data),
      );
    } on DioException catch (error) {
      return error.toApiResult<TransferResponse>();
    }
  }
}