import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Presentation/provider/multiple_provider.dart';
import '../Presentation/provider/permission_provider.dart';

const String defaultBaseUrl = "https://3l4vre4apl.execute-api.ap-south-1.amazonaws.com/dev";

class AppConfig {

  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  String baseUrl = defaultBaseUrl;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString('base_url') ?? defaultBaseUrl;
  }

  Future<void> updateBaseUrl({required BuildContext context, required String newUrl}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('base_url', newUrl);
    baseUrl = newUrl;
    final permissionProvider = PermissionProvider();
    await permissionProvider.checkAndRequestPermissions();
    runApp(MultipleProvider(permissionProvider: permissionProvider));
    context.pop();
  }
}

final appConfig = AppConfig();