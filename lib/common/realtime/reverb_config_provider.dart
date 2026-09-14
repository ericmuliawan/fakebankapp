import 'package:rml_fakebank_app/common/local_storage_provider.dart';

class ReverbConnectionConfig {
  const ReverbConnectionConfig({
    required this.apiKey,
    required this.host,
    required this.port,
    required this.useTLS,
    required this.authEndpoint,
  });

  final String apiKey;
  final String host;
  final int port;
  final bool useTLS;
  final String authEndpoint;
}

abstract class IReverbConfigProvider {
  ReverbConnectionConfig get connection;
  Map<String, String> buildAuthHeaders();
}

class ReverbConfigProvider implements IReverbConfigProvider {
  ReverbConfigProvider({required ILocalStorageProvider localStorageProvider})
    : _localStorageProvider = localStorageProvider;

  final ILocalStorageProvider _localStorageProvider;

  static const _connection = ReverbConnectionConfig(
    apiKey: 'vascomm-api-key',
    host: 'reverb.vascomm.id',
    port: 443,
    useTLS: true,
    authEndpoint: 'https://reverb.vascomm.id/broadcasting/auth',
  );

  @override
  ReverbConnectionConfig get connection => _connection;

  @override
  Map<String, String> buildAuthHeaders() {
    final token = _localStorageProvider.getAuthToken();

    return {
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
}
