import 'package:equatable/equatable.dart';

class TransferRequest extends Equatable {
  const TransferRequest({
    required this.recipientAccount,
    required this.amount,
    required this.notes,
  });

  final String recipientAccount;
  final int amount;
  final String notes;

  Map<String, dynamic> toJson() => {
    'recipient_account': recipientAccount,
    'amount': amount,
    'notes': notes,
  };

  @override
  List<Object?> get props => [recipientAccount, amount, notes];
}