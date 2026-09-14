import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/di/service_locator.dart';
import 'common/network/auth_interceptor.dart';
import 'uikit/token/index.dart';
import 'feature/auth/domain/repositories/auth_repository.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/auth/presentation/bloc/auth_event.dart';
import 'feature/auth/presentation/bloc/auth_state.dart';
import 'feature/auth/presentation/pages/auth_page.dart';
import 'feature/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'feature/dashboard/presentation/pages/dashboard_page.dart';
import 'feature/history/domain/repositories/history_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const FakeBankApp());
}

class FakeBankApp extends StatelessWidget {
  const FakeBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FakeBank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColor.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColor.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.radius10),
            borderSide: const BorderSide(color: AppColor.neutralAlt),
          ),
        ),
      ),
      home: AuthGate(bloc: getIt<AuthBloc>()),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.bloc});

  final AuthBloc bloc;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  StreamSubscription<void>? _unauthorizedSubscription;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(const AuthStarted());
    _unauthorizedSubscription = getIt<AuthInterceptor>().onUnauthorized.listen(
      (_) {
        if (mounted) {
          widget.bloc.add(const LogoutRequested());
        }
      },
    );
  }

  @override
  void dispose() {
    _unauthorizedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: widget.bloc,
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        switch (state) {
          case AuthInitial():
          case AuthLoading():
          case AuthRestoring():
          case AuthUnauthenticated():
          case AuthError():
          case AuthRegistered():
            return AuthPage(bloc: widget.bloc);
          case AuthAuthenticated():
            return DashboardPage(
              bloc: DashboardBloc(
                repository: getIt<IAuthRepository>(),
                historyRepository: getIt<IHistoryRepository>(),
              ),
              authBloc: widget.bloc,
            );
        }
      },
    );
  }
}