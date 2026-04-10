import 'dart:convert';
import 'dart:io';

import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../Data/model/response_model/inspection_pre_save_req_model.dart';
import '../../Presentation/screens/login_page/login_screen.dart';
import '../../Presentation/screens/manual_inspection_images/DocumentManualDocModels.dart';

class ApiService {
  // static Future<Map<String, dynamic>> post(dynamic body, String apiUrl) async {
  //   final response = await http.post(Uri.parse(apiUrl),
  //       headers: authHeader, body: jsonEncode(body));
  //   if (kDebugMode) {
  //     alice.onHttpResponse(response, body: jsonEncode(body));
  //   }
  //   final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
  //   if (response.statusCode == 200) {
  //     return responseBody;
  //   } else {
  //     return responseBody;
  //   }
  // }

  static Future<Map<String, dynamic>?> post(dynamic body, String apiUrl) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ${Preferences.getToken()}',
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(body),
    );
    if (kDebugMode) {
      alice.onHttpResponse(response, body: jsonEncode(body));
    }

    /// Check Token Expire 401 - Send Login Screen
    if (response.statusCode == 401) {
      final responseBody = await compute(_decodeResponse, response.bodyBytes);

      if (responseBody['Message'] == 'Invalid credentials') {
        return responseBody;
      }

      await Preferences.clear();

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
      return responseBody;
    }


    final responseBody = await compute(_decodeResponse, response.bodyBytes);
    return responseBody;
  }

  /// Multipart Method
  // static Future<Map<String, dynamic>> multipart(Map<String, String> body, File file, String apiUrl, {String fileKey = "image"}) async {
  //   final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  //   request.headers.addAll(authHeader);
  //   request.fields.addAll(body);
  //   request.files.add(await http.MultipartFile.fromPath(fileKey, file.path, contentType: MediaType('image', 'jpeg')));
  //   final streamedResponse = await request.send();
  //   final response = await http.Response.fromStream(streamedResponse);
  //   if (kDebugMode) {
  //     alice.onHttpResponse(response, body: jsonEncode(body));
  //   }
  //   final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
  //   if (response.statusCode == 200) {
  //     return responseBody;
  //   } else {
  //     return responseBody;
  //   }
  // }

  static Future<Map<String, dynamic>?> multipart(
    Map<String, String> body,
    File file,
      String apiUrl, {
    String fileKey = "image",
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(authHeader);
    request.fields.addAll(body);
    request.files.add(
      await http.MultipartFile.fromPath(
        fileKey,
        file.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (kDebugMode) {
      alice.onHttpResponse(response, body: jsonEncode(body));
    }

    if (response.statusCode == 401) {

      await Preferences.clear();

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );

      return {};
    }

    final responseBody = await compute(_decodeResponse, response.bodyBytes);
    return responseBody;
  }

  static Map<String, dynamic> _decodeResponse(Uint8List bodyBytes) {
    return jsonDecode(utf8.decode(bodyBytes));
  }

  /// Manual Doc Upload
  static Future<Map<String, dynamic>?> manualDocMultipartUpload({
    required String appointmentId,
    required String createdBy,
    required String vehicleId,
    required List<DocumentManualDocModels> documents,
    required String apiUrl,

  }) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer ${Preferences.getToken()}',
    };
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);
    request.fields['appointment_id'] = appointmentId;
    request.fields['created_by'] = createdBy;
    request.fields['vehicle_id'] = vehicleId;
    for (int i = 0; i < documents.length; i++) {
      final doc = documents[i];
      request.fields['documents[$i].label_id'] = doc.labelId;
      request.fields['documents[$i].latitude'] = doc.latitude;
      request.fields['documents[$i].longitude'] = doc.longitude;
      request.files.add(
        await http.MultipartFile.fromPath(
          'documents[$i].file',
          doc.file.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (kDebugMode) {
      alice.onHttpResponse(response, body: request.fields);
    }

    if (response.statusCode == 401) {

      await Preferences.clear();

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );

      return {};
    }
    final responseBody = await compute(_decodeResponse, response.bodyBytes);
    return responseBody;
  }

  /// Pre Save Inspection
  static Future<Map<String, dynamic>?> preSaveInspectionMultipartUpload({
    required String appointmentId,
    required String inspectedBy,
    required String vehicleId,
    required List<InspectionPreSaveReqModel> inspections,
    required String apiUrl,
  }) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer ${Preferences.getToken()}',
    };
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);
    request.fields['appointment_id'] = appointmentId;
    request.fields['vehicle_id'] = vehicleId;
    request.fields['inspected_by'] = inspectedBy;
    for (int i = 0; i < inspections.length; i++) {
      final item = inspections[i];
      request.fields['inspections[$i].question_id'] = item.questionId;
      request.fields['inspections[$i].inspection_result'] =
          item.inspectionResult;
      request.fields['inspections[$i].severity_level'] = item.severityLevel;
      request.fields['inspections[$i].remarks'] = item.remarks;
      final image = item.image1;
      if (image != null && image.path.isNotEmpty && await image.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'inspections[$i].image1',
            image.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
        debugPrint('✅ Image sent [$i]: ${image.path}');
      } else {
        debugPrint('⏭️ No image for [$i]: ${item.questionId}');
      }
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (kDebugMode) {
      alice.onHttpResponse(response, body: request.fields);
    }

    if (response.statusCode == 401) {

      await Preferences.clear();

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );

      return {};
    }

    final responseBody = await compute(_decodeResponse, response.bodyBytes);
    return responseBody;
  }
}
