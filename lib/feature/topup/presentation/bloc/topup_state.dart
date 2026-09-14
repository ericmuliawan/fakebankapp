import 'package:equatable/equatable.dart';

import '../../data/models/topup_response.dart';

sealed class TopUpState extends Equatable {
  const TopUpState();

  @override
  List<Object?> get props => [];
}

class TopUpInitial extends TopUpState {
  const TopUpInitial();
}

class TopUpSubmitting extends TopUpState {
  const TopUpSubmitting();
}

class TopUpSuccess extends TopUpState {
  const TopUpSuccess({required this.response, required this.amount});

  final TopUpResponse response;
  final int amount;

  @override
  List<Object?> get props => [response, amount];
}

class TopUpError extends TopUpState {
  const TopUpError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
