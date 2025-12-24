

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? instance;

  static String userId = 'userId';
  static String token = 'token';


  static Future<void> setPreferences() async {
    instance = await SharedPreferences.getInstance();
  }

  static Future<bool> clear() => instance!.clear();

  static Future<bool> setString(String key, String value) {
    return instance!.setString(key, value);
  }

  static dynamic getString(String key) {
    return instance!.get(key) ?? "";
  }

  static Future<bool> setUserId(String value) =>setString(userId, value);
  static Future<bool> setToken(String value) =>setString(token, value);


  static dynamic getUserId() => getString(userId);
  static dynamic getToken() => getString(token);


}
