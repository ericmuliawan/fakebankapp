import 'package:equatable/equatable.dart';

abstract class TopUpEvent extends Equatable {
  const TopUpEvent();

  @override
  List<Object?> get props => [];
}

class TopUpSubmitted extends TopUpEvent {
  const TopUpSubmitted({required this.amount});

  final int amount;

  @override
  List<Object?> get props => [amount];
}
