import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../new_model/auth_model.dart';


enum SaveResult { savedToServer, savedLocally, failed }

class StorageResult {
  final SaveResult result;
  final String savedPath;
  final String? serverUrl;   // URL returned by server after upload
  final String? error;
  final bool isLocal;

  const StorageResult({
    required this.result,
    required this.savedPath,
    this.serverUrl,
    this.error,
    required this.isLocal,
  });
}

class StorageService {

  // ── Upload photo via API ──────────────────────────────────────────────────
  //
  // POST {serverUrl}/api/v1/media
  // Headers:
  //   Authorization: Bearer {apiKey}
  //   Content-Type: multipart/form-data
  // Fields:
  //   file         → binary photo bytes
  //   type         → "photo" | "video"
  //   category     → "vehicle_photo" | "evidence"
  //   vehicle_reg  → registration number
  //   angle        → front/rear/leftSide/... (vehicle photos only)
  //   item_ref     → inspection item ref e.g. "02" (evidence only)
  //   filename     → original filename
  //   captured_at  → ISO datetime
  //   latitude     → GPS lat
  //   longitude    → GPS lng
  //   address      → reverse geocoded address

  static Future<StorageResult> savePhoto({
    required Uint8List bytes,
    required String filename,
    required AppConfig config,
    String vehicleReg = '',
    String category = 'vehicle_photo',  // "vehicle_photo" or "evidence"
    String angle = '',                   // front, rear, leftSide...
    String itemRef = '',                 // inspection item ref
    double lat = 0,
    double lng = 0,
    String address = '',
    String capturedAt = '',
  }) async {
    if (kIsWeb) {
      return const StorageResult(
          result: SaveResult.savedLocally, savedPath: 'memory', isLocal: true);
    }

    // ── 1. Try API upload ─────────────────────────────────────────────────
    if (config.uploadPhotosToServer && config.serverUrl.isNotEmpty) {
      final result = await _uploadMedia(
        bytes: bytes,
        filename: filename,
        config: config,
        fields: {
          'type':         'photo',
          'category':     category,
          'vehicle_reg':  vehicleReg,
          'angle':        angle,
          'item_ref':     itemRef,
          'filename':     filename,
          'captured_at':  capturedAt,
          'latitude':     lat.toStringAsFixed(6),
          'longitude':    lng.toStringAsFixed(6),
          'address':      address,
        },
      );
      if (result != null) {
        return StorageResult(
          result: SaveResult.savedToServer,
          savedPath: result,
          serverUrl: result,
          isLocal: false,
        );
      }
      debugPrint('[Storage] API unreachable — saving locally');
    }

    // ── 2. Local device path ──────────────────────────────────────────────
    final local = await _saveToPath(
        bytes: bytes, filename: filename, dirPath: config.photoSavePath);
    if (local != null) {
      return StorageResult(
          result: SaveResult.savedLocally, savedPath: local, isLocal: true,
          error: 'Server unreachable — saved locally');
    }

    // ── 3. App documents fallback ─────────────────────────────────────────
    final fallback = await _saveToFallback(bytes: bytes, filename: filename);
    return fallback != null
        ? StorageResult(
            result: SaveResult.savedLocally,
            savedPath: fallback,
            isLocal: true,
            error: 'Saved to app folder (configured path unavailable)',
          )
        : const StorageResult(
            result: SaveResult.failed,
            savedPath: '',
            isLocal: true,
            error: 'Failed to save photo',
          );
  }

  // ── Upload video via API ──────────────────────────────────────────────────
  static Future<StorageResult> saveVideo({
    required String filePath,
    required String filename,
    required AppConfig config,
    String vehicleReg = '',
    String itemRef = '',
    double lat = 0,
    double lng = 0,
    String address = '',
    String capturedAt = '',
  }) async {
    if (kIsWeb) {
      return const StorageResult(
          result: SaveResult.savedLocally, savedPath: 'memory', isLocal: true);
    }

    // ── 1. Try API upload ─────────────────────────────────────────────────
    if (config.uploadVideosToServer && config.serverUrl.isNotEmpty) {
      try {
        final bytes = await File(filePath).readAsBytes();
        final result = await _uploadMedia(
          bytes: bytes,
          filename: filename,
          config: config,
          fields: {
            'type':        'video',
            'category':    'evidence',
            'vehicle_reg': vehicleReg,
            'item_ref':    itemRef,
            'filename':    filename,
            'captured_at': capturedAt,
            'latitude':    lat.toStringAsFixed(6),
            'longitude':   lng.toStringAsFixed(6),
            'address':     address,
          },
        );
        if (result != null) {
          return StorageResult(
              result: SaveResult.savedToServer,
              savedPath: result,
              serverUrl: result,
              isLocal: false);
        }
      } catch (e) {
        debugPrint('[Storage] Video upload error: $e');
      }
    }

    // ── 2. Local video path ───────────────────────────────────────────────
    try {
      final dir = Directory(config.videoSavePath);
      if (!await dir.exists()) await dir.create(recursive: true);
      final dest = '${config.videoSavePath}/$filename';
      await File(filePath).copy(dest);
      return StorageResult(
          result: SaveResult.savedLocally, savedPath: dest, isLocal: true,
          error: 'Server unreachable — saved locally');
    } catch (_) {}

    return StorageResult(
      result: SaveResult.savedLocally,
      savedPath: filePath,
      isLocal: true,
      error: 'Saved in camera folder',
    );
  }

  // ── Core multipart POST ───────────────────────────────────────────────────
  static Future<String?> _uploadMedia({
    required Uint8List bytes,
    required String filename,
    required AppConfig config,
    required Map<String, String> fields,
  }) async {
    try {
      final uri = Uri.parse(
        '${config.serverUrl.trimRight()}/api/v1/media',
      );

      final request = http.MultipartRequest('POST', uri);

      // Auth header
      if (config.apiKey.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${config.apiKey}';
      }

      // Extra metadata fields
      request.fields.addAll(fields);

      // File
      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: filename),
      );

      debugPrint('[Storage] POST $uri  fields: ${fields['type']}/${fields['category']}');

      final streamed = await request.send()
          .timeout(Duration(seconds: config.apiTimeoutSeconds));

      final body = await streamed.stream.bytesToString();
      debugPrint('[Storage] Response ${streamed.statusCode}: $body');

      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        // Try to parse URL from response JSON
        try {
          final json = _parseJson(body);
          return json['url'] ?? json['path'] ?? json['file_url'] ??
              '${config.serverUrl.trimRight()}/api/v1/media/$filename';
        } catch (_) {
          return '${config.serverUrl.trimRight()}/api/v1/media/$filename';
        }
      }
      debugPrint('[Storage] API returned ${streamed.statusCode}: $body');
      return null;
    } catch (e) {
      debugPrint('[Storage] Upload failed: $e');
      return null;
    }
  }

  // ── Simple JSON field extractor (no package needed) ───────────────────────
  static Map<String, dynamic> _parseJson(String body) {
    final result = <String, dynamic>{};
    final urlMatch = RegExp(r'"url"\s*:\s*"([^"]+)"').firstMatch(body);
    final pathMatch = RegExp(r'"path"\s*:\s*"([^"]+)"').firstMatch(body);
    final fileUrlMatch = RegExp(r'"file_url"\s*:\s*"([^"]+)"').firstMatch(body);
    if (urlMatch != null)     result['url']      = urlMatch.group(1);
    if (pathMatch != null)    result['path']     = pathMatch.group(1);
    if (fileUrlMatch != null) result['file_url'] = fileUrlMatch.group(1);
    return result;
  }

  // ── Local path ────────────────────────────────────────────────────────────
  static Future<String?> _saveToPath({
    required Uint8List bytes,
    required String filename,
    required String dirPath,
  }) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) await dir.create(recursive: true);
      final path = '$dirPath/$filename';
      await File(path).writeAsBytes(bytes);
      debugPrint('[Storage] Saved locally: $path');
      return path;
    } catch (e) {
      debugPrint('[Storage] Local save failed ($dirPath): $e');
      return null;
    }
  }

  // ── App docs fallback ──────────────────────────────────────────────────────
  static Future<String?> _saveToFallback({
    required Uint8List bytes,
    required String filename,
  }) async {
    try {
      Directory base;
      try {
        base = await getApplicationDocumentsDirectory();
      } catch (_) {
        base = await getTemporaryDirectory();
      }
      final dir = Directory('${base.path}/AVIS');
      if (!await dir.exists()) await dir.create(recursive: true);
      final path = '${dir.path}/$filename';
      await File(path).writeAsBytes(bytes);
      debugPrint('[Storage] Fallback: $path');
      return path;
    } catch (e) {
      debugPrint('[Storage] Fallback failed: $e');
      return null;
    }
  }

  // ── Reachability check ────────────────────────────────────────────────────
  static Future<bool> isServerReachable(AppConfig config) async {
    if (kIsWeb || config.serverUrl.isEmpty) return false;
    try {
      final uri = Uri.parse('${config.serverUrl.trimRight()}/health');
      final resp = await http.get(uri,
          headers: config.apiKey.isNotEmpty
              ? {'Authorization': 'Bearer ${config.apiKey}'}
              : {})
          .timeout(const Duration(seconds: 5));
      return resp.statusCode < 500;
    } catch (_) {
      return false;
    }
  }
}
