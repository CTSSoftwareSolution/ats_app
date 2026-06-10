import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../new_model/auth_model.dart';
import '../new_model/inspection_model.dart';
import '../new_model/vehicle_entry.dart';
import '../new_model/vehicle_photos_model.dart';
import 'debug_service.dart';
import 'label_service.dart';

enum UploadStatus { idle, uploading, success, failed }

class UploadProgress {
  final int total;
  final int done;
  final int failed;
  final String currentFile;
  final UploadStatus status;

  const UploadProgress({
    this.total = 0,
    this.done = 0,
    this.failed = 0,
    this.currentFile = '',
    this.status = UploadStatus.idle,
  });

  double get percent => total == 0 ? 0 : done / total;
  bool get isComplete => status == UploadStatus.success ||
      status == UploadStatus.failed;
}

// Label IDs are loaded from {fullApiBase}/inspection/inspection-label-list
// and accessed via LabelService.getLabelId(angleName)

class UploadService {

  // ── Step 1: Vehicle Photos — single multipart request ──────────────────────
  // All 8 photos sent in ONE request:
  //   documents[0].label_id / latitude / longitude / file
  //   documents[1].label_id / latitude / longitude / file
  //   ...
  static Future<UploadProgress> uploadVehiclePhotos({
    required VehicleEntry vehicle,
    required AppConfig config,
    required Function(UploadProgress) onProgress,
  }) async {
    DebugService.log('UPLOAD',
        'Step1 vehicle=' + vehicle.regNo + ' photos=' + vehicle.photos.length.toString());

    final photos = vehicle.photos.values.toList();

    if (photos.isEmpty) {
      DebugService.log('UPLOAD', 'No photos in map!');
      final p = const UploadProgress(total: 0, done: 0, status: UploadStatus.success);
      onProgress(p);
      return p;
    }

    onProgress(UploadProgress(
      total: 1, done: 0, failed: 0,
      currentFile: 'Preparing ' + photos.length.toString() + ' photos...',
      status: UploadStatus.uploading,
    ));

    final url = config.fullApiBase + '/inspection/upload';
    final uri = Uri.parse(url);

    DebugService.apiRequest('POST', url, authToken: config.apiKey);

    final request = http.MultipartRequest('POST', uri);

    if (config.apiKey.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer ' + config.apiKey;
    }

    // Top-level fields matching UploadInspectionDocumentRequest
    request.fields['vehicle_id']     = vehicle.regNo;
    request.fields['appointment_id'] = (int.tryParse(vehicle.appointmentId) ?? 0).toString();
    request.fields['created_by']     = config.createdBy.isEmpty
        ? '00000000-0000-0000-0000-000000000000'
        : config.createdBy;

    DebugService.log('FIELDS',
        'vehicle_id=' + vehicle.regNo +
        '  appointment_id=' + vehicle.appointmentId +
        '  created_by=' + config.createdBy +
        '  total_files=' + photos.length.toString());

    // Sort photos in fixed label order (1→8) to match server sequence
    const angleOrder = [
      'front', 'rear', 'engine', 'leftSide',
      'rightSide', 'chassis', 'dashboard', 'odometer',
    ];
    photos.sort((a, b) {
      final ai = angleOrder.indexOf(a.angle.name);
      final bi = angleOrder.indexOf(b.angle.name);
      return (ai < 0 ? 99 : ai).compareTo(bi < 0 ? 99 : bi);
    });

    int attached = 0;
    for (int i = 0; i < photos.length; i++) {
      final photo   = photos[i];
      // Use sequential position to get label_id (1-based)
      final labelId = LabelService.getLabelIdByIndex(i);
      final label   = vehiclePhotoLabel(photo.angle);

      // Get bytes — memory first, then read from file
      Uint8List? fileBytes = photo.bytes;
      if ((fileBytes == null || fileBytes.isEmpty) &&
          !kIsWeb && photo.path.isNotEmpty && photo.path != 'memory') {
        final file = File(photo.path);
        if (await file.exists()) {
          fileBytes = await file.readAsBytes();
        }
      }

      if (fileBytes == null || fileBytes.isEmpty) {
        DebugService.log('WARN', 'Skipping ' + photo.angle.name + ' — no bytes');
        continue;
      }

      final filename = vehicle.regNo + '_' + photo.angle.name +
          '_' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

      request.fields['documents[$i].label_id']  = labelId.toString();
      request.fields['documents[$i].latitude']  = photo.latitude.toStringAsFixed(6);
      request.fields['documents[$i].longitude'] = photo.longitude.toStringAsFixed(6);
      request.files.add(http.MultipartFile.fromBytes(
        'documents[$i].file',
        fileBytes,
        filename: filename,
      ));

      DebugService.log('ATTACH',
          '[$i] ' + label + '  labelId=' + labelId.toString() +
          '  ' + (fileBytes.length / 1024).toStringAsFixed(1) + ' KB');
      attached++;
    }

    if (attached == 0) {
      DebugService.log('UPLOAD', 'No files could be attached');
      final p = const UploadProgress(total: 1, done: 0, failed: 1, status: UploadStatus.failed);
      onProgress(p);
      return p;
    }

    try {
      DebugService.log('UPLOAD', 'Sending ' + attached.toString() + ' files in single request...');

      // Use longer timeout for batch upload
      final streamed = await request.send()
          .timeout(Duration(seconds: config.apiTimeoutSeconds * attached));
      final body = await streamed.stream.bytesToString();

      DebugService.apiResponse(streamed.statusCode, body);

      final ok = _parseSuccess(body, streamed.statusCode);
      final errMsg = ok ? null : _parseMessage(body) ??
          'HTTP ' + streamed.statusCode.toString();

      DebugService.uploadFile(
        vehicle.regNo + '_vehicle_photos_x' + attached.toString(),
        sizeBytes: null, ok: ok, error: errMsg,
      );

      final p = UploadProgress(
        total: 1, done: ok ? 1 : 0, failed: ok ? 0 : 1,
        currentFile: '',
        status: ok ? UploadStatus.success : UploadStatus.failed,
      );
      onProgress(p);
      return p;
    } catch (e) {
      DebugService.uploadFile(vehicle.regNo + '_vehicle_photos',
          ok: false, error: e.toString());
      final p = const UploadProgress(total: 1, done: 0, failed: 1, status: UploadStatus.failed);
      onProgress(p);
      return p;
    }
  }


  // ── Step 2: Pre-Inspection media ───────────────────────────────────────────
  static Future<UploadProgress> uploadPreInspection({
    required VehicleEntry vehicle,
    required AppConfig config,
    required Function(UploadProgress) onProgress,
  }) async =>
      _uploadInspectionMedia(
        vehicle: vehicle,
        sections: vehicle.preSections,
        phase: 'pre_inspection',
        config: config,
        onProgress: onProgress,
      );

  // ── Step 3: Post-Inspection media ──────────────────────────────────────────
  static Future<UploadProgress> uploadPostInspection({
    required VehicleEntry vehicle,
    required AppConfig config,
    required Function(UploadProgress) onProgress,
  }) async =>
      _uploadInspectionMedia(
        vehicle: vehicle,
        sections: vehicle.postSections,
        phase: 'post_inspection',
        config: config,
        onProgress: onProgress,
      );

  static Future<UploadProgress> _uploadInspectionMedia({
    required VehicleEntry vehicle,
    required List<InspectionSection> sections,
    required String phase,
    required AppConfig config,
    required Function(UploadProgress) onProgress,
  }) async {
    final allMedia = <Map<String, dynamic>>[];
    for (final s in sections) {
      for (final item in s.items) {
        if (item.media.isNotEmpty) {
          DebugService.log('UPLOAD',
            'Item ${item.ref} has ${item.media.length} media file(s)');
        }
        for (final m in item.media) {
          allMedia.add({
            'media':    m,
            'item_ref': item.ref,
            // Use question_id directly as label_id for evidence items
            'label_id': int.tryParse(item.ref) ?? 0,
          });
        }
      }
    }

    DebugService.log('UPLOAD',
        '$phase — total media to upload: ${allMedia.length}');

    if (allMedia.isEmpty) {
      final p = const UploadProgress(
          total: 0, done: 0, status: UploadStatus.success);
      onProgress(p);
      return p;
    }

    int done = 0, failed = 0;
    final total = allMedia.length;

    for (final e in allMedia) {
      final media   = e['media']    as MediaFile;
      final itemRef = e['item_ref'] as String;
      final labelId = e['label_id'] as int;
      final ext     = media.type == MediaType.video ? 'mp4' : 'jpg';
      final filename =
          '${vehicle.regNo}_${phase}_${itemRef}_'
          '${DateTime.now().millisecondsSinceEpoch}.$ext';

      final typeLabel = media.type == MediaType.video ? 'Video' : 'Photo';
      onProgress(UploadProgress(
        total: total, done: done, failed: failed,
        currentFile: '$typeLabel — Item $itemRef (${done + 1}/$total)',
        status: UploadStatus.uploading,
      ));

      final ok = await _uploadInspectionDocument(
        bytes: media.bytes,
        filePath: media.path,
        filename: filename,
        config: config,
        vehicleId: vehicle.regNo,
        appointmentId: int.tryParse(vehicle.appointmentId) ?? 0,
        labelId: labelId,
        latitude: media.geoTag.latitude,
        longitude: media.geoTag.longitude,
      );

      if (ok) done++; else failed++;
    }

    final status = failed == 0 ? UploadStatus.success : UploadStatus.failed;
    final p = UploadProgress(
        total: total, done: done, failed: failed, status: status);
    onProgress(p);
    return p;
  }

  // ── POST /api/inspection/upload ────────────────────────────────────────────
  // Body: multipart/form-data
  //   vehicle_id      → string
  //   appointment_id  → int
  //   created_by      → Guid (user id from JWT)
  //   documents[0].label_id   → int
  //   documents[0].latitude   → decimal
  //   documents[0].longitude  → decimal
  //   documents[0].file       → binary
  static Future<bool> _uploadInspectionDocument({
    required Uint8List? bytes,
    required String filePath,
    required String filename,
    required AppConfig config,
    required String vehicleId,
    required int appointmentId,
    required int labelId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Get file bytes
      Uint8List? fileBytes = bytes;
      if ((fileBytes == null || fileBytes.isEmpty) &&
          !kIsWeb && filePath.isNotEmpty && filePath != 'memory') {
        final file = File(filePath);
        if (await file.exists()) {
          fileBytes = await file.readAsBytes();
          DebugService.log('FILE',
              'Read ${fileBytes.length} bytes from disk');
        } else {
          DebugService.uploadFile(filename,
              ok: false, error: 'File not found: $filePath');
          return false;
        }
      }

      if (fileBytes == null || fileBytes.isEmpty) {
        DebugService.uploadFile(filename,
            ok: false, error: 'No bytes available');
        return false;
      }

      final url =
          '${config.fullApiBase}/inspection/upload';
      final uri = Uri.parse(url);

      DebugService.apiRequest('POST', url, authToken: config.apiKey);
      DebugService.log('FIELDS',
          'vehicle_id=$vehicleId  appointment_id=$appointmentId  '
          'label_id=$labelId  lat=$latitude  lng=$longitude');
      DebugService.log('SIZE',
          '${(fileBytes.length / 1024).toStringAsFixed(1)} KB  file=$filename');

      final request = http.MultipartRequest('POST', uri);

      // Auth header
      if (config.apiKey.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${config.apiKey}';
      }

      // Top-level fields matching UploadInspectionDocumentRequest
      request.fields['vehicle_id']     = vehicleId;
      request.fields['appointment_id'] = appointmentId.toString();

      // created_by — parse user id from JWT if available
      // Sent as Guid string e.g. "4fc698d3-7c27-4c46-89b7-174cb9e5eaa7"
      // The config.apiKey is the JWT — we pass created_by as a field
      // AppProvider injects userId via config; fallback to empty Guid
      request.fields['created_by'] = config.createdBy.isEmpty
          ? '00000000-0000-0000-0000-000000000000'
          : config.createdBy;

      // documents[0] — single file per request
      request.fields['documents[0].label_id']   = labelId.toString();
      request.fields['documents[0].latitude']   = latitude.toStringAsFixed(6);
      request.fields['documents[0].longitude']  = longitude.toStringAsFixed(6);
      request.files.add(http.MultipartFile.fromBytes(
        'documents[0].file',
        fileBytes,
        filename: filename,
      ));

      final streamed = await request.send()
          .timeout(Duration(seconds: config.apiTimeoutSeconds));
      final body = await streamed.stream.bytesToString();

      DebugService.apiResponse(streamed.statusCode, body);

      final ok = _parseSuccess(body, streamed.statusCode);
      DebugService.uploadFile(filename,
          sizeBytes: fileBytes.length, ok: ok,
          error: ok ? null : _parseMessage(body));

      return ok;
    } catch (e) {
      DebugService.uploadFile(filename, ok: false, error: e.toString());
      return false;
    }
  }

  // ── Response helpers ──────────────────────────────────────────────────────
  // Handles both:
  //   { "Success": true,  "Message": "...", "Data": {} }   ← ApiResponse<T>
  //   { "status": false,  "message": "..." }               ← validation errors
  static bool _parseSuccess(String body, int statusCode) {
    if (statusCode < 200 || statusCode >= 300) return false;
    try {
      // Check "Success" (capital S) — ApiResponse<T>
      if (body.contains('"Success":true') || body.contains('"Success": true')) {
        return true;
      }
      // Check "status" (lowercase) — validation/not-found responses
      if (body.contains('"status":false') || body.contains('"status": false')) {
        return false;
      }
      // Any 2xx without explicit false = success
      return true;
    } catch (_) {
      return statusCode >= 200 && statusCode < 300;
    }
  }

  static String? _parseMessage(String body) {
    try {
      // "Message": "..."
      final mMatch = RegExp(r'"[Mm]essage"\s*:\s*"([^"]+)"').firstMatch(body);
      return mMatch?.group(1);
    } catch (_) {
      return null;
    }
  }
}