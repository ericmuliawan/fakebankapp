import 'package:equatable/equatable.dart';

class TopUpResponse extends Equatable {
  const TopUpResponse({required this.referenceNo});

  final String referenceNo;

  factory TopUpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return TopUpResponse(referenceNo: data['reference_no']?.toString() ?? '');
  }

  @override
  List<Object?> get props => [referenceNo];
}
