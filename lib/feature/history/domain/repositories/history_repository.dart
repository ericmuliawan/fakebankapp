import '../../../../model/common/api_result.dart';
import '../../domain/entities/transaction.dart';

abstract interface class IHistoryRepository {
  Future<ApiResult<List<Transaction>>> getHistory({int? limit});
}