import 'package:equatable/equatable.dart';

import '../../data/models/transfer_response.dart';

sealed class TransferState extends Equatable {
  const TransferState();

  @override
  List<Object?> get props => [];
}

class TransferInitial extends TransferState {
  const TransferInitial();
}

class TransferSubmitting extends TransferState {
  const TransferSubmitting();
}

class TransferSuccess extends TransferState {
  const TransferSuccess({
    required this.response,
    required this.amount,
    required this.recipientAccount,
    required this.notes,
  });

  final TransferResponse response;
  final int amount;
  final String recipientAccount;
  final String notes;

  @override
  List<Object?> get props => [response, amount, recipientAccount, notes];
}

class TransferError extends TransferState {
  const TransferError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}