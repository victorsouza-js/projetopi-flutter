import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> removeString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> containsString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.containsKey(key);
  }
}