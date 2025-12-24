import 'dart:convert';

import 'package:ats_app/Core/network/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> post(dynamic body, String apiUrl) async {
    final response = await http.post(Uri.parse(apiUrl),
        headers: authHeader, body: jsonEncode(body));
    if (kDebugMode) {
      alice.onHttpResponse(response, body: jsonEncode(body));
    }
    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      return responseBody;
    }
  }
}