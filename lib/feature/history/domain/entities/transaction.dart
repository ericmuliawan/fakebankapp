import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  const Transaction({
    required this.amount,
    required this.transactionType,
    required this.transactionDate,
  });

  final double amount;
  final String transactionType;
  final DateTime transactionDate;

  bool get isTransfer => transactionType.toUpperCase() == 'TRANSFER';

  String get typeLabel => isTransfer ? 'Transfer' : transactionType;

  @override
  List<Object?> get props => [amount, transactionType, transactionDate];
}