import 'package:equatable/equatable.dart';

import '../../../../feature/auth/domain/entities/profile.dart';
import '../../../../feature/history/domain/entities/transaction.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded({
    required this.profile,
    this.recentTransactions = const [],
  });

  final Profile profile;
  final List<Transaction> recentTransactions;

  @override
  List<Object?> get props => [profile, recentTransactions];
}

class DashboardError extends DashboardState {
  const DashboardError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}