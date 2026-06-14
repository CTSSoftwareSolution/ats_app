import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../new_model/auth_model.dart';
import '../new_model/inspection_model.dart';
import 'debug_service.dart';

class InspectionResultService {

  // ── POST /api/inspection/submit-item ─────────────────────────────────────
  // Sends result + observation + all media files for ONE question in one request
  static Future<bool> submitItem({
    required AppConfig config,
    required String vehicleId,
    required int appointmentId,
    required InspectionItem item,
  }) async {
    try {
      final url = '${config.fullApiBase}/inspection/submit-item';

      DebugService.apiRequest('POST', url, authToken: config.apiKey,
          fields: {
            'vehicle_id':     vehicleId,
            'appointment_id': appointmentId.toString(),
            'question_id':    item.questionId.toString(),
            'result':         item.resultLabel,
            'observation':    item.observation,
            'severity_level': item.complexity,
            'files':          item.media.length.toString(),
          });

      final request = http.MultipartRequest('POST', Uri.parse(url));

      if (config.apiKey.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${config.apiKey}';
      }

      // ── Top-level fields ──────────────────────────────────────────
      request.fields['vehicle_id']     = vehicleId;
      request.fields['appointment_id'] = appointmentId.toString();
      request.fields['created_by']     = config.createdBy.isEmpty
          ? '00000000-0000-0000-0000-000000000000'
          : config.createdBy;
      request.fields['question_id']    = item.questionId.toString();
      request.fields['result']         = item.resultLabel;
      request.fields['observation']    = item.observation;
      request.fields['severity_level'] = item.complexity;  // High | Medium | Low

      // ── Attach media files ────────────────────────────────────────
      int attached = 0;
      for (int i = 0; i < item.media.length; i++) {
        final m = item.media[i];

        Uint8List? bytes = m.bytes;
        if ((bytes == null || bytes.isEmpty) &&
            !kIsWeb && m.path.isNotEmpty && m.path != 'memory') {
          final file = File(m.path);
          if (await file.exists()) {
            bytes = await file.readAsBytes();
          }
        }

        if (bytes == null || bytes.isEmpty) {
          DebugService.log('WARN',
              'Skipping media[$i] for item ${item.ref} — no bytes');
          continue;
        }

        final ext      = m.type == MediaType.video ? 'mp4' : 'jpg';
        final filename = '${vehicleId}_q${item.ref}_${i}_'
            '${DateTime.now().millisecondsSinceEpoch}.$ext';
        final labelId  = int.tryParse(item.ref) ?? 0;

        request.fields['documents[$i].label_id']  = labelId.toString();
        request.fields['documents[$i].latitude']  =
            m.geoTag.latitude.toStringAsFixed(6);
        request.fields['documents[$i].longitude'] =
            m.geoTag.longitude.toStringAsFixed(6);
        request.files.add(http.MultipartFile.fromBytes(
            'documents[$i].file', bytes, filename: filename));

        DebugService.log('ATTACH',
            '[$i] ${m.type.name}  labelId=$labelId  '
                '${(bytes.length / 1024).toStringAsFixed(1)} KB');
        attached++;
      }

      DebugService.log('UPLOAD',
          'Sending q${item.questionId}(${item.ref}) — result=${item.resultLabel} '
              'files=$attached');

      final streamed = await request.send()
          .timeout(Duration(seconds: config.apiTimeoutSeconds *
          (attached > 0 ? attached + 1 : 1)));
      final body = await streamed.stream.bytesToString();

      DebugService.apiResponse(streamed.statusCode, body);

      if (streamed.statusCode == 200) {
        final json = jsonDecode(body) as Map<String, dynamic>;
        return json['Success'] == true || json['status'] == true;
      }
      return false;
    } catch (e) {
      DebugService.log('RES✗', 'submit-item error: $e');
      debugPrint('[InspectionResultService] $e');
      return false;
    }
  }

  // ── POST /api/inspection/submit-result (single, no files) ────────────────
  // Kept for backward compatibility — used when no media is attached
  static Future<bool> submitSingle({
    required AppConfig config,
    required String vehicleId,
    required int appointmentId,
    required InspectionItem item,
  }) async {
    // If item has media, use the combined endpoint instead
    if (item.media.isNotEmpty) {
      return submitItem(
        config:        config,
        vehicleId:     vehicleId,
        appointmentId: appointmentId,
        item:          item,
      );
    }

    try {
      final url  = '${config.fullApiBase}/inspection/submit-result';
      final body = {
        'vehicle_id':     vehicleId,
        'appointment_id': appointmentId,
        'created_by':     config.createdBy.isEmpty
            ? '00000000-0000-0000-0000-000000000000'
            : config.createdBy,
        'question_id':    item.questionId,
        'result':         item.resultLabel,
        'observation':    item.observation,
      };

      DebugService.apiRequest('POST', url, authToken: config.apiKey,
          fields: body.map((k, v) => MapEntry(k, v.toString())));

      final response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Content-Type':  'application/json',
          'Accept':        'application/json',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: config.apiTimeoutSeconds));

      DebugService.apiResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['Success'] == true || json['status'] == true;
      }
      return false;
    } catch (e) {
      DebugService.log('RES✗', 'submit-result error: $e');
      return false;
    }
  }
}
