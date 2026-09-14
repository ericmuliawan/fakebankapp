import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/transfer_response.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../../../../model/common/api_result.dart';
import 'transfer_event.dart';
import 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc({required ITransferRepository repository})
      : _repository = repository,
        super(const TransferInitial()) {
    on<TransferSubmitted>(_onSubmitted);
  }

  final ITransferRepository _repository;

  Future<void> _onSubmitted(
    TransferSubmitted event,
    Emitter<TransferState> emit,
  ) async {
    emit(const TransferSubmitting());
    final result = await _repository.transfer(
      recipientAccount: event.recipientAccount,
      amount: event.amount,
      notes: event.notes,
    );
    switch (result) {
      case Success<TransferResponse>(:final response):
        emit(
          TransferSuccess(
            response: response,
            amount: event.amount,
            recipientAccount: event.recipientAccount,
            notes: event.notes,
          ),
        );
      case Error<TransferResponse>(:final error):
        emit(
          TransferError(
            message: error.message ?? 'Transfer failed. Please try again.',
          ),
        );
    }
  }
}