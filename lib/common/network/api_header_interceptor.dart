import 'package:dio/dio.dart';

import 'package:rml_fakebank_app/common/local_storage_provider.dart';
import 'package:rml_fakebank_app/data/env/env.dart';

class ApiHeaderInterceptor extends Interceptor {
  ApiHeaderInterceptor({required ILocalStorageProvider localStorageProvider})
    : _localStorageProvider = localStorageProvider;

  final ILocalStorageProvider _localStorageProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('Accept', () => 'application/json; charset=UTF-8');
    options.headers.putIfAbsent('x-api-key', () => Env.apiAccessKey);

    final authToken = _localStorageProvider.getAuthToken();
    if (authToken.isNotEmpty) {
      options.headers.putIfAbsent('Authorization', () => 'Bearer $authToken');
    }

    handler.next(options);
  }
}
