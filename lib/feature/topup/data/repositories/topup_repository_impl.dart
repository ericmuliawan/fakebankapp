import '../../../../model/common/api_result.dart';
import '../../domain/repositories/topup_repository.dart';
import '../datasources/topup_remote_datasource.dart';
import '../models/topup_response.dart';

class TopUpRepository implements ITopUpRepository {
  TopUpRepository({required ITopUpRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ITopUpRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<TopUpResponse>> topUp(int amount) {
    return _remoteDataSource.topUp(amount);
  }
}
