import 'package:equatable/equatable.dart';

class TopUpRequest extends Equatable {
  const TopUpRequest({required this.amount});

  final int amount;

  Map<String, dynamic> toJson() => {'amount': amount};

  @override
  List<Object?> get props => [amount];
}
