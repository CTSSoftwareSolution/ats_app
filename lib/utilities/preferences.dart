import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? instance;

  static String userId = 'userId';
  static String token = 'token';
  static String name = 'name';
  static String email = 'email';
  static String image = 'image';
  static String location = 'location';
  static String ipAddress = 'ipAddress';

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

  static Future<bool> setUserId(String value) => setString(userId, value);
  static Future<bool> setToken(String value) => setString(token, value);
  static Future<bool> setName(String value) => setString(name, value);
  static Future<bool> setEmail(String value) => setString(email, value);
  static Future<bool> setImage(String value) => setString(image, value);
  static Future<bool> setLocation(String value) => setString(location, value);
  static Future<bool> setIPAddress(String value) => setString(ipAddress, value);

  static dynamic getUserId() => getString(userId);
  static dynamic getToken() => getString(token);
  static dynamic getName() => getString(name);
  static dynamic getEmail() => getString(email);
  static dynamic getImage() => getString(image);
  static dynamic getLocation() => getString(location);
  static dynamic getIPAddress() => getString(ipAddress);
}
