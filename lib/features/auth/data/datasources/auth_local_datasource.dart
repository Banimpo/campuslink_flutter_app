import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSource({required this.storage});

  static const tokenKey = 'access_token';

  Future<void> saveToken(String token) {
    return storage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() {
    return storage.read(key: tokenKey);
  }

  Future<void> deleteToken() {
    return storage.delete(key: tokenKey);
  }
}
