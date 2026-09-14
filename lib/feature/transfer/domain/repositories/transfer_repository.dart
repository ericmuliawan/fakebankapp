import 'package:rml_fakebank_app/model/common/api_result.dart';

import '../../data/models/transfer_response.dart';

abstract interface class ITransferRepository {
  Future<ApiResult<TransferResponse>> transfer({
    required String recipientAccount,
    required int amount,
    required String notes,
  });
}