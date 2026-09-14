import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../feature/auth/domain/entities/profile.dart';
import '../../../../feature/auth/domain/repositories/auth_repository.dart';
import '../../../../feature/history/domain/entities/transaction.dart';
import '../../../../feature/history/domain/repositories/history_repository.dart';
import '../../../../model/common/api_result.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required IAuthRepository repository,
    required IHistoryRepository historyRepository,
  })  : _repository = repository,
        _historyRepository = historyRepository,
        super(const DashboardInitial()) {
    on<DashboardOpened>(_onOpened);
  }

  final IAuthRepository _repository;
  final IHistoryRepository _historyRepository;

  static const _recentCount = 5;

  Future<void> _onOpened(
    DashboardOpened event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final (profileResult, historyResult) = await (
      _repository.getProfile(),
      _historyRepository.getHistory(limit: _recentCount),
    ).wait;

    switch (profileResult) {
      case Success<Profile>(:final response):
        final recentTransactions = switch (historyResult) {
          Success<List<Transaction>>(:final response) => response,
          Error<List<Transaction>>() => <Transaction>[],
        };
        emit(
          DashboardLoaded(
            profile: response,
            recentTransactions: recentTransactions,
          ),
        );
      case Error<Profile>(:final error):
        emit(
          DashboardError(message: error.message ?? 'Failed to load profile'),
        );
    }
  }
}