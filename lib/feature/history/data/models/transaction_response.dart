import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';

class TransactionResponse extends Equatable {
  const TransactionResponse({
    required this.amount,
    required this.transactionType,
    required this.transactionDate,
  });

  final double amount;
  final String transactionType;
  final DateTime transactionDate;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0,
      transactionType: json['transaction_type']?.toString() ?? '',
      transactionDate:
          DateTime.tryParse(json['transaction_date']?.toString() ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Transaction toEntity() {
    return Transaction(
      amount: amount,
      transactionType: transactionType,
      transactionDate: transactionDate,
    );
  }

  @override
  List<Object?> get props => [amount, transactionType, transactionDate];
}