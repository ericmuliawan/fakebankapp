import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/common/api_result.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/history_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({required IHistoryRepository repository})
      : _repository = repository,
        super(const HistoryInitial()) {
    on<HistoryRequested>(_onHistoryRequested);
  }

  final IHistoryRepository _repository;

  Future<void> _onHistoryRequested(
    HistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    final result = await _repository.getHistory(limit: event.limit);
    switch (result) {
      case Success<List<Transaction>>(:final response):
        emit(HistoryLoaded(transactions: response));
      case Error<List<Transaction>>(:final error):
        emit(HistoryError(message: error.message ?? 'Failed to load history'));
    }
  }
}