import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> add(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    try {
      String? data = await _secureStorage.read(key: key);
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<void> remove(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } finally {}
  }
}
