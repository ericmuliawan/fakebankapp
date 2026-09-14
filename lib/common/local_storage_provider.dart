import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalStorageProvider {
  Future<void> setAuthToken(String token);
  String getAuthToken();

  Future<void> setUserLogin(bool isLogin);
  bool getUserLogin();

  Future<void> setUserEmail(String email);
  String getUserEmail();

  Future<void> deleteAuthToken();
}

class LocalStorageProvider implements ILocalStorageProvider {
  LocalStorageProvider({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const _keyAuthToken = 'auth_token';
  static const _isLogin = 'isLogin';
  static const _keyUserEmail = 'user_email';

  @override
  Future<void> setAuthToken(String token) async {
    await _prefs.setString(_keyAuthToken, token);
  }

  @override
  String getAuthToken() {
    return _prefs.getString(_keyAuthToken) ?? '';
  }

  @override
  Future<void> setUserLogin(bool isLogin) async {
    await _prefs.setBool(_isLogin, isLogin);
  }

  @override
  bool getUserLogin() {
    return _prefs.getBool(_isLogin) ?? false;
  }

  @override
  Future<void> setUserEmail(String email) async {
    await _prefs.setString(_keyUserEmail, email);
  }

  @override
  String getUserEmail() {
    return _prefs.getString(_keyUserEmail) ?? '';
  }

  @override
  Future<void> deleteAuthToken() async {
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_isLogin);
    await _prefs.remove(_keyUserEmail);
  }
}
