import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../uikit/button/primary_button.dart';
import '../../../../uikit/token/index.dart';
import '../../../../uikit/widget/textfield/index.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

enum _AuthMode { login, register }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.bloc});

  final AuthBloc bloc;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _AuthMode _mode = _AuthMode.login;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _canSubmit() {
    final hasEmail = _emailController.text.trim().isNotEmpty;
    final hasPassword = _passwordController.text.isNotEmpty;
    if (_mode == _AuthMode.register) {
      return _fullNameController.text.trim().isNotEmpty &&
          hasEmail &&
          hasPassword;
    }
    return hasEmail && hasPassword;
  }

  void _onToggle(_AuthMode mode) {
    if (_mode == mode) return;
    setState(() {
      _mode = mode;
      _errorMessage = null;
    });
  }

  void _onSubmit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (_mode == _AuthMode.login) {
      widget.bloc.add(LoginSubmitted(email: email, password: password));
    } else {
      widget.bloc.add(
        RegisterSubmitted(
          fullName: _fullNameController.text.trim(),
          email: email,
          password: password,
        ),
      );
    }
  }

  void _listenToState(BuildContext context, AuthState state) {
    if (state is AuthRegistered) {
      setState(() {
        _mode = _AuthMode.login;
        _emailController.text = _emailController.text.trim();
        _passwordController.clear();
        _errorMessage = null;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Account created. Please sign in.'),
            backgroundColor: AppColor.greenSnackBar,
            behavior: SnackBarBehavior.floating,
          ),
        );
    } else if (state is AuthError) {
      setState(() => _errorMessage = state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: widget.bloc,
      listener: _listenToState,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.primaryDark,
                AppColor.primary,
                AppColor.primaryLight,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const _BrandHeader(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.radius28),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacing24,
                        vertical: AppSpacing.spacing24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _AuthModeSwitch(mode: _mode, onChanged: _onToggle),
                          const SizedBox(height: AppSpacing.spacing24),
                          if (_mode == _AuthMode.register) ...[
                            OutlinedTextField(
                              controller: _fullNameController,
                              hintText: 'Full name',
                              prefixIcon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                              onTextChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: AppSpacing.spacing14),
                          ],
                          OutlinedTextField(
                            controller: _emailController,
                            hintText: 'Email address',
                            prefixIcon: Icons.mail_outline,
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onTextChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: AppSpacing.spacing14),
                          OutlinedTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onTextChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: AppSpacing.spacing20),
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(
                                AppSpacing.spacing12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.redNotif,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.radius8,
                                ),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: AppTextStyle.bodyMedium.apply(
                                  color: AppColor.error,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spacing16),
                          ],
                          BlocBuilder<AuthBloc, AuthState>(
                            bloc: widget.bloc,
                            builder: (context, state) {
                              final isLoading =
                                  state is AuthLoading ||
                                  state is AuthRestoring;
                              return PrimaryButton(
                                buttonText: _mode == _AuthMode.login
                                    ? 'Sign In'
                                    : 'Create Account',
                                isEnabled: !isLoading && _canSubmit(),
                                onPressed: isLoading ? () {} : _onSubmit,
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.spacing20),
                          Center(
                            child: Text(
                              _mode == _AuthMode.login
                                  ? 'New to FakeBank?'
                                  : 'Already have an account?',
                              style: AppTextStyle.bodyMedium.apply(
                                color: AppColor.textSecondary,
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () => _onToggle(
                                _mode == _AuthMode.login
                                    ? _AuthMode.register
                                    : _AuthMode.login,
                              ),
                              child: Text(
                                _mode == _AuthMode.login
                                    ? 'Create an account'
                                    : 'Sign in instead',
                                style: AppTextStyle.bodyLargeBold.apply(
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spacing8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing24,
        AppSpacing.spacing40,
        AppSpacing.spacing24,
        AppSpacing.spacing32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.accent, AppColor.primaryLight],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(Icons.account_balance, color: AppColor.white, size: 36),
          ),
          const SizedBox(height: AppSpacing.spacing16),
          const Text(
            'FakeBank',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 28,
              height: 1.2,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing4),
          Text(
            'Your trusted digital banking',
            style: AppTextStyle.bodyLarge.apply(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _AuthModeSwitch extends StatelessWidget {
  const _AuthModeSwitch({required this.mode, required this.onChanged});

  final _AuthMode mode;
  final ValueChanged<_AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.radius12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeTab(
              label: 'Sign In',
              isActive: mode == _AuthMode.login,
              onTap: () => onChanged(_AuthMode.login),
            ),
          ),
          Expanded(
            child: _ModeTab(
              label: 'Create Account',
              isActive: mode == _AuthMode.register,
              onTap: () => onChanged(_AuthMode.register),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing12),
        decoration: BoxDecoration(
          color: isActive ? AppColor.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColor.primary.withValues(alpha: 0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyle.labelMedium.apply(
            color: isActive ? AppColor.white : AppColor.textSecondary,
          ),
        ),
      ),
    );
  }
}
