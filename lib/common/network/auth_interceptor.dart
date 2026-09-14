import 'dart:async';

import 'package:dio/dio.dart';

import 'package:rml_fakebank_app/common/local_storage_provider.dart';

/// Catches HTTP 401 responses, clears the stored session, and notifies
/// listeners (e.g. AuthGate) so the app can return to the login screen.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required ILocalStorageProvider localStorageProvider})
    : _localStorageProvider = localStorageProvider;

  final ILocalStorageProvider _localStorageProvider;
  final StreamController<void> _unauthorizedController =
      StreamController<void>.broadcast();

  Stream<void> get onUnauthorized => _unauthorizedController.stream;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      unawaited(_handleUnauthorized());
    }
    handler.next(err);
  }

  Future<void> _handleUnauthorized() async {
    await _localStorageProvider.deleteAuthToken();
    if (!_unauthorizedController.isClosed) {
      _unauthorizedController.add(null);
    }
  }

  void dispose() {
    _unauthorizedController.close();
  }
}