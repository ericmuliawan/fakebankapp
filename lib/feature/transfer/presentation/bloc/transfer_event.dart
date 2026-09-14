import 'package:equatable/equatable.dart';

abstract class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object?> get props => [];
}

class TransferSubmitted extends TransferEvent {
  const TransferSubmitted({
    required this.recipientAccount,
    required this.amount,
    required this.notes,
  });

  final String recipientAccount;
  final int amount;
  final String notes;

  @override
  List<Object?> get props => [recipientAccount, amount, notes];
}