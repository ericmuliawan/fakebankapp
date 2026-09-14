import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthRestoring extends AuthState {
  const AuthRestoring();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.session});

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

class AuthRegistered extends AuthState {
  const AuthRegistered({required this.userId});

  final int userId;

  @override
  List<Object?> get props => [userId];
}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}