import 'dart:convert';
import 'dart:io';

import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alice/model/alice_form_data_file.dart';
import 'package:flutter_alice/model/alice_from_data_field.dart';
import 'package:flutter_alice/model/alice_http_call.dart';
import 'package:flutter_alice/model/alice_http_error.dart';
import 'package:flutter_alice/model/alice_http_request.dart';
import 'package:flutter_alice/model/alice_http_response.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../Data/model/request_model/create_bulk_req_model.dart';
import '../../Data/model/response_model/inspection_pre_save_req_model.dart';
import '../../Presentation/provider/create_queue_provider.dart';
import '../../Presentation/screens/login_page/login_screen.dart';
import '../../Presentation/screens/manual_inspection_images/document_manual_doc_models.dart';

class ApiService {
  /// On session expiry (401), drop stored queue image paths so they don't
  /// carry over to the next login.
  static Future<void> _clearUploadedQueueImages() async {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    try {
      await context.read<CreateQueueProvider>().clearUploadedImages();
    } catch (e) {
      debugPrint('[MEDIA] Failed to clear stored image paths on 401: $e');
    }
  }

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
      await _clearUploadedQueueImages();

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
      await _clearUploadedQueueImages();

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
      await _clearUploadedQueueImages();
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
      return {};
    }
    final responseBody = await compute(_decodeResponse, response.bodyBytes);
    return responseBody;
  }

  /// Manual Pre Save Inspection
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
      await _clearUploadedQueueImages();

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );

      return {};
    }

    final responseBody = await compute(_decodeResponse, response.bodyBytes);
    return responseBody;
  }

  static Future<Map<String, dynamic>?> aiMultipartUpload({
    required String registrationNumber,
    required String applicationNumber,
    required String createdBy,
    required String appointmentId,
    required List<CreateBulkReqModel> mediaType,
    required String apiUrl,
  }) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer ${Preferences.getToken()}',
    };
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.headers.addAll(headers);
    request.fields['registration_no'] = registrationNumber;
    request.fields['application_no'] = applicationNumber;
    request.fields['created_by'] = createdBy;
    request.fields['appointment_id'] = appointmentId;

    for (int i = 0; i < mediaType.length; i++) {
      final item = mediaType[i];
      request.fields['questions[$i].question_id'] = item.questionId;
      final image = item.images;
      if (image != null && image.path.isNotEmpty && await image.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'questions[$i].image',
            image.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
        debugPrint('Image sent [$i]: ${image.path}');
      } else {
        debugPrint('No image for [$i]: ${item.questionId}');
      }

      final video = item.videos;
      if(video != null && video.path.isNotEmpty && await video.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'questions[$i].video',
            video.path,
            contentType: MediaType('video', 'mp4'),
          ),
        );
        debugPrint('Video sent [$i]: ${video.path}');
      }else {
        debugPrint('No video for [$i]: ${item.questionId}');
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (kDebugMode) {
      alice.onHttpResponse(response, body: request.fields);
    }

    final responseBody = await compute(_decodeResponse, response.bodyBytes);
    return responseBody;
  }

  /// Machine Pre Save Inspection
  static Future<Map<String, dynamic>?> aiSaveInspectionMultipartUpload({
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
      await _clearUploadedQueueImages();

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );

      return {};
    }

    final responseBody = await compute(_decodeResponse, response.bodyBytes);
    return responseBody;
  }


  Future<http.Response> postMultipart({
    required String apiUrl,
    required Map<String, String> fields,
    String? imagePath,
    String? videoPath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(apiUrl),
    );

    request.headers.addAll(authHeader);
    request.fields.addAll(fields);

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imagePath,
        ),
      );
    }

    if (videoPath != null && videoPath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          videoPath,
        ),
      );
    }

    final stopwatch = Stopwatch()..start();
    final http.Response response;
    try {
      final streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        _logMultipartToAlice(request, stopwatch.elapsedMilliseconds,
            error: e, stackTrace: stackTrace);
      }
      rethrow;
    }

    if (kDebugMode) {
      _logMultipartToAlice(request, stopwatch.elapsedMilliseconds,
          response: response);
      debugPrint("Create Queue => ${request.method} ${request.url}");
      debugPrint("Fields: ${request.fields}");
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Response: ${response.body}");
    }

    return response;
  }

  /// Alice's built-in http adapter drops headers / files for MultipartRequest,
  /// so build the call manually to see the complete request in the inspector.
  static void _logMultipartToAlice(
    http.MultipartRequest request,
    int durationMs, {
    http.Response? response,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final call = AliceHttpCall(request.hashCode)
      ..client = "HttpClient (http package)"
      ..method = request.method
      ..uri = request.url.toString()
      ..endpoint = request.url.path.isEmpty ? "/" : request.url.path
      ..server = request.url.host
      ..secure = request.url.scheme == "https"
      ..duration = durationMs
      ..loading = false;

    // Headers are read after send() so they include the multipart boundary.
    call.request = AliceHttpRequest()
      ..headers = Map<String, dynamic>.from(request.headers)
      ..contentType = request.headers[HttpHeaders.contentTypeHeader] ??
          request.headers['Content-Type']
      ..body = request.fields
      ..size = request.contentLength
      ..queryParameters = request.url.queryParameters
      ..formDataFields = request.fields.entries
          .map((e) => AliceFormDataField(e.key, e.value))
          .toList()
      ..formDataFiles = request.files
          .map((f) => AliceFormDataFile(
                '${f.field}: ${f.filename ?? ''}',
                f.contentType.toString(),
                f.length,
              ))
          .toList();

    if (response != null) {
      call.response = AliceHttpResponse()
        ..status = response.statusCode
        ..body = response.body
        ..size = response.bodyBytes.length
        ..headers = Map<String, String>.from(response.headers);
    } else {
      call.response = AliceHttpResponse()..status = -1;
      call.error = AliceHttpError()
        ..error = error
        ..stackTrace = stackTrace;
    }

    alice.addHttpCall(call);
  }


}
