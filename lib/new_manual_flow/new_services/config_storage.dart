import 'package:shared_preferences/shared_preferences.dart';

/// Stores server URL persistently — independent of login session.
/// This means the server URL survives logout and is pre-filled on next login.
class ConfigStorage {
  static const _keyServerUrl    = 'cfg_server_url';
  static const _keyApiBasePath  = 'cfg_api_base_path';

  static const String defaultServerUrl   = 'http://192.168.1.5';
  static const String defaultApiBasePath = '/api';

  static Future<String> getServerUrl() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyServerUrl) ?? defaultServerUrl;
  }

  static Future<String> getApiBasePath() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyApiBasePath) ?? defaultApiBasePath;
  }

  static Future<void> saveServerUrl(String url) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyServerUrl, url.trim());
  }

  static Future<void> saveApiBasePath(String path) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyApiBasePath, path.trim());
  }

  static Future<void> save({required String serverUrl,
    required String apiBasePath}) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyServerUrl, serverUrl.trim());
    await p.setString(_keyApiBasePath, apiBasePath.trim());
  }
}
