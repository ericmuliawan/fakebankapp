import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/di/service_locator.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../model/common/api_result.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({IAuthRepository? repository})
    : _repository = repository ?? getIt<IAuthRepository>(),
      super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final IAuthRepository _repository;

  Future<void> _onStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthRestoring());
    final result = await _repository.restoreSession();
    switch (result) {
      case Success<AuthSession>(:final response):
        emit(AuthAuthenticated(session: response));
      case Error<AuthSession>():
        emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _repository.login(
      email: event.email,
      password: event.password,
    );
    switch (result) {
      case Success<AuthSession>(:final response):
        emit(AuthAuthenticated(session: response));
      case Error<AuthSession>(:final error):
        emit(AuthError(message: error.message ?? 'Login failed'));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _repository.register(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
    );
    switch (result) {
      case Success<int>(:final response):
        emit(AuthRegistered(userId: response));
      case Error<int>(:final error):
        emit(AuthError(message: error.message ?? 'Registration failed'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(const AuthUnauthenticated());
  }
}