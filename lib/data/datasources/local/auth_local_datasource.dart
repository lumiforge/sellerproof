import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sellerproof/data/models/api_models.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _storage;
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userInfoKey = 'user_info';

  AuthLocalDataSource(this._storage);

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> saveUser(UserInfo user) async {
    await _storage.write(key: _userInfoKey, value: jsonEncode(user.toJson()));
  }

  Future<UserInfo?> getUser() async {
    final jsonStr = await _storage.read(key: _userInfoKey);
    if (jsonStr == null) return null;
    try {
      return UserInfo.fromJson(jsonDecode(jsonStr));
    } catch (_) {
      return null;
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userInfoKey);
  }
}
