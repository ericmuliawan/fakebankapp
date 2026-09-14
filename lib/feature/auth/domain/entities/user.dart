import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;

  @override
  List<Object?> get props => [id, name, email, phone];
}

class AuthSession extends Equatable {
  const AuthSession({
    required this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.user,
  });

  final String accessToken;
  final String? tokenType;
  final int? expiresIn;
  final User? user;

  @override
  List<Object?> get props => [accessToken, tokenType, expiresIn, user];
}