abstract class LocalStorage {
  Future<void> add(String key, String value);
  Future<String?> get(String key);
  Future<void> remove(String key);
}
