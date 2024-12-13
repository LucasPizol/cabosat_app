import 'package:cabosat/services/implementations/local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService implements LocalStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> add(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> get(String key) async {
    try {
      String? data = await _secureStorage.read(key: key);
      print("Data: $data");
      return data;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  @override
  Future<void> remove(String key) async {
    await _secureStorage.delete(key: key);
  }
}
