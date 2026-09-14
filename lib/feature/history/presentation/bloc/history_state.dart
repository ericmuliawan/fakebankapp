import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded({required this.transactions});

  final List<Transaction> transactions;

  @override
  List<Object?> get props => [transactions];
}

class HistoryError extends HistoryState {
  const HistoryError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}