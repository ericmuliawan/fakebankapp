import 'package:equatable/equatable.dart';

class ProfileResponse extends Equatable {
  const ProfileResponse({
    required this.id,
    required this.email,
    required this.balance,
    required this.fullName,
    required this.accountNumber,
  });

  final int id;
  final String email;
  final double balance;
  final String fullName;
  final String accountNumber;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return ProfileResponse(
      id: data['id'] is num ? (data['id'] as num).toInt() : 0,
      email: data['email']?.toString() ?? '',
      balance: (data['balance'] is num) ? (data['balance'] as num).toDouble() : 0,
      fullName: data['full_name']?.toString() ?? '',
      accountNumber: data['account_number']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, email, balance, fullName, accountNumber];
}