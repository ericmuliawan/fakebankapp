import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  const LoginResponse({
    required this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  final String accessToken;
  final String? tokenType;
  final int? expiresIn;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return LoginResponse(
      accessToken: data['access_token']?.toString() ?? '',
      tokenType: data['token_type']?.toString(),
      expiresIn: data['expires_in'] is int ? data['expires_in'] as int : null,
    );
  }

  @override
  List<Object?> get props => [accessToken, tokenType, expiresIn];
}