import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  final FlutterSecureStorage _storage;

  StorageHelper(this._storage);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> saveAccessToken(String token) async =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<void> saveRefreshToken(String token) async =>
      _storage.write(key: _refreshTokenKey, value: token);

  Future<String?> getAccessToken() async => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() async =>
      _storage.read(key: _refreshTokenKey);

  Future<void> clearAccessToken() async =>
      _storage.delete(key: _accessTokenKey);

  Future<void> clearRefreshToken() async =>
      _storage.delete(key: _refreshTokenKey);

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
