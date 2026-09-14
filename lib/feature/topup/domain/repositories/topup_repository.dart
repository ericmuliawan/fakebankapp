import '../../../../model/common/api_result.dart';
import '../../data/models/topup_response.dart';

abstract interface class ITopUpRepository {
  Future<ApiResult<TopUpResponse>> topUp(int amount);
}
