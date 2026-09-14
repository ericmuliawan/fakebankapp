import 'package:equatable/equatable.dart';

class RegisterResponse extends Equatable {
  const RegisterResponse({required this.userId});

  final int userId;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return RegisterResponse(
      userId: data['user_id'] is int ? data['user_id'] as int : 0,
    );
  }

  @override
  List<Object?> get props => [userId];
}