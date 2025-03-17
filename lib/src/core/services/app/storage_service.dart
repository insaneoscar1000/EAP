import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final Future<SharedPreferences> _storage = SharedPreferences.getInstance();

  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await _storage;
    return prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await _storage;
    prefs.setString(key, value);
  }

  Future<void> clearAll() async {
    final SharedPreferences prefs = await _storage;
    prefs.clear();
  }
}
