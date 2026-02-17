import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utilities/preferences.dart';

class IpAddressProvider extends ChangeNotifier {


  // Default base URL
  static const String _defaultBaseUrl = 'https://3l4vre4apl.execute-api.ap-south-1.amazonaws.com/dev';

  String _baseUrl = _defaultBaseUrl;

  String get baseUrl => _baseUrl;

  IpAddressProvider() {
    loadBaseUrl();
  }

  /// Load saved base URL from local storage
  Future<void> loadBaseUrl() async {
    final savedIp = Preferences.getIPAddress();
    if (savedIp.isNotEmpty) {
      _baseUrl = savedIp;
    } else {
      _baseUrl = _defaultBaseUrl;
    }
    notifyListeners();
  }

  /// Update and save new base URL
  Future<bool> updateBaseUrl(String newUrl) async {
    try {
      if (!newUrl.startsWith('http')) {
        newUrl = "http://$newUrl";
      }

      _baseUrl = newUrl;

      await Preferences.setIPAddress(newUrl);

      notifyListeners();
      return true;

    } catch (e) {
      debugPrint('Error saving base URL: $e');
      return false;
    }
  }



  /// Reset to default base URL
  Future<void> resetToDefault() async {
    _baseUrl = _defaultBaseUrl;
    await Preferences.setIPAddress("");
    notifyListeners();
  }
}
