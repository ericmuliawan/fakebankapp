import '../../../../model/common/api_result.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_datasource.dart';
import '../models/transaction_response.dart';

class HistoryRepository implements IHistoryRepository {
  HistoryRepository({required IHistoryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final IHistoryRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<Transaction>>> getHistory({int? limit}) async {
    final result = await _remoteDataSource.getHistory(limit: limit);
    return switch (result) {
      Success<List<TransactionResponse>>(:final response) =>
        ApiResult.success(response.map((e) => e.toEntity()).toList()),
      Error<List<TransactionResponse>>(:final error) =>
        ApiResult.error(error),
    };
  }
}