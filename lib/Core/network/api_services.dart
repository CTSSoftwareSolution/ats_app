import 'dart:convert';
import 'dart:io';

import 'package:ats_app/Core/network/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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

  /// Multipart Method
  static Future<Map<String, dynamic>> multipart(Map<String, String> body, File file, String apiUrl, {String fileKey = "image"}) async {
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(authHeader);
    request.fields.addAll(body);
    request.files.add(await http.MultipartFile.fromPath(fileKey, file.path, contentType: MediaType('image', 'jpeg')));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
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