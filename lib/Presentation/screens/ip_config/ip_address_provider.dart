import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpAddressProvider extends ChangeNotifier {
  static const String _storageKey = 'base_url';

  // Default base URL
  static const String _defaultBaseUrl = 'http://192.168.1.1:8080';

  String _baseUrl = _defaultBaseUrl;

  String get baseUrl => _baseUrl;

  IpAddressProvider() {
    _loadBaseUrl();
  }

  /// Load saved base URL from local storage
  Future<void> _loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString(_storageKey) ?? _defaultBaseUrl;
    notifyListeners();
  }

  /// Update and save new base URL
  Future<bool> updateBaseUrl(String newUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _baseUrl = newUrl;
      await prefs.setString(_storageKey, newUrl);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving base URL: $e');
      return false;
    }
  }

  /// Reset to default base URL
  Future<void> resetToDefault() async {
    final prefs = await SharedPreferences.getInstance();

    _baseUrl = _defaultBaseUrl;
    await prefs.setString(_storageKey, _defaultBaseUrl);

    notifyListeners();
  }
}
