import 'package:equatable/equatable.dart';

class TransferResponse extends Equatable {
  const TransferResponse({required this.referenceNo});

  final String referenceNo;

  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return TransferResponse(
      referenceNo: data['reference_no']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [referenceNo];
}