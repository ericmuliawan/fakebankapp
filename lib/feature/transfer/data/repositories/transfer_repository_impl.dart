import 'package:rml_fakebank_app/feature/transfer/data/datasources/transfer_remote_datasource.dart';
import 'package:rml_fakebank_app/feature/transfer/data/models/transfer_request.dart';
import 'package:rml_fakebank_app/feature/transfer/data/models/transfer_response.dart';
import 'package:rml_fakebank_app/feature/transfer/domain/repositories/transfer_repository.dart';
import 'package:rml_fakebank_app/model/common/api_result.dart';

class TransferRepository implements ITransferRepository {
  TransferRepository({required ITransferRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final ITransferRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<TransferResponse>> transfer({
    required String recipientAccount,
    required int amount,
    required String notes,
  }) async {
    return _remoteDataSource.transfer(
      TransferRequest(
        recipientAccount: recipientAccount,
        amount: amount,
        notes: notes,
      ),
    );
  }
}