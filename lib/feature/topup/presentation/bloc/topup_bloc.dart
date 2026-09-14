import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/common/api_result.dart';
import '../../data/models/topup_response.dart';
import '../../domain/repositories/topup_repository.dart';
import 'topup_event.dart';
import 'topup_state.dart';

class TopUpBloc extends Bloc<TopUpEvent, TopUpState> {
  TopUpBloc({required ITopUpRepository repository})
    : _repository = repository,
      super(const TopUpInitial()) {
    on<TopUpSubmitted>(_onSubmitted);
  }

  final ITopUpRepository _repository;

  Future<void> _onSubmitted(
    TopUpSubmitted event,
    Emitter<TopUpState> emit,
  ) async {
    emit(const TopUpSubmitting());
    final result = await _repository.topUp(event.amount);
    switch (result) {
      case Success<TopUpResponse>(:final response):
        emit(TopUpSuccess(response: response, amount: event.amount));
      case Error<TopUpResponse>(:final error):
        emit(
          TopUpError(
            message: error.message ?? 'Top up failed. Please try again.',
          ),
        );
    }
  }
}
