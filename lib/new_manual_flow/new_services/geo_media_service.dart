import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../new_model/auth_model.dart';
import '../new_model/inspection_model.dart';
import 'location_service.dart';
import 'storage_service.dart';

class GeoMediaService {
  static final _picker = ImagePicker();
  static const _uuid = Uuid();

  // ── Capture evidence photo ────────────────────────────────────────────────
  static Future<MediaFile?> capturePhoto({
    AppConfig? config,
    String vehicleReg = '',
    String itemRef = '',
  }) async {
    // ── Start GPS in background, open camera immediately ──────────────────
    final geoFuture = LocationService.getCurrentLocation();

    final xfile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: config?.photoQuality ?? 92,
      maxWidth: 2560,
    );
    if (xfile == null) return null;

    // Read bytes and wait for GPS in parallel
    final rawBytesFuture = xfile.readAsBytes();
    final geo = await geoFuture;
    final rawBytes = await rawBytesFuture;

    final geoTag = GeoTag(
      latitude:   geo.latitude,
      longitude:  geo.longitude,
      address:    geo.address,
      capturedAt: geo.capturedAt,
    );

    // Stamp
    Uint8List finalBytes;
    if (config?.stampGpsOnPhoto ?? true) {
      final stamped = await _stampPhoto(rawBytes, geoTag);
      finalBytes = stamped ?? rawBytes;
    } else {
      finalBytes = rawBytes;
    }

    final filename = _buildFilename(vehicleReg, 'evidence', itemRef,
        config?.photoFormat ?? 'jpg');

    String savedPath = xfile.path;
    bool toServer = false;
    String? note;

    if (!kIsWeb) {
      if (config != null) {
        final result = await StorageService.savePhoto(
          bytes: finalBytes,
          filename: filename,
          config: config,
          vehicleReg: vehicleReg,
          category: 'evidence',
          itemRef: itemRef,
          lat: geo.latitude,
          lng: geo.longitude,
          address: geo.address,
          capturedAt: geo.capturedAt.toIso8601String(),
        );
        savedPath = result.savedPath;
        toServer  = !result.isLocal;
        note      = result.error;
      } else {
        final tmp = await getTemporaryDirectory();
        savedPath = '${tmp.path}/$filename';
        await File(savedPath).writeAsBytes(finalBytes);
      }
    }

    return MediaFile(
      id: _uuid.v4(), path: savedPath, bytes: finalBytes,
      type: MediaType.photo, geoTag: geoTag,
      savedToServer: toServer, storageNote: note,
    );
  }

  // ── Capture evidence video ────────────────────────────────────────────────
  static Future<MediaFile?> captureVideo({
    AppConfig? config,
    String vehicleReg = '',
    String itemRef = '',
  }) async {
    // GPS starts before camera opens
    final geoFuture = LocationService.getCurrentLocation();

    final xfile = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(minutes: config?.maxVideoMinutes ?? 3),
    );
    if (xfile == null) return null;

    final geo = await geoFuture;

    final geoTag = GeoTag(
      latitude:   geo.latitude,
      longitude:  geo.longitude,
      address:    geo.address,
      capturedAt: geo.capturedAt,
    );

    final filename = _buildFilename(vehicleReg, 'evidence_video', itemRef, 'mp4');

    String savedPath = xfile.path;
    bool toServer = false;
    String? note;

    if (!kIsWeb && config != null) {
      final result = await StorageService.saveVideo(
        filePath: xfile.path,
        filename: filename,
        config: config,
        vehicleReg: vehicleReg,
        itemRef: itemRef,
        lat: geo.latitude,
        lng: geo.longitude,
        address: geo.address,
        capturedAt: geo.capturedAt.toIso8601String(),
      );
      savedPath = result.savedPath;
      toServer  = !result.isLocal;
      note      = result.error;
    }

    return MediaFile(
      id: _uuid.v4(), path: savedPath, bytes: null,
      type: MediaType.video, geoTag: geoTag,
      savedToServer: toServer, storageNote: note,
    );
  }

  static String _buildFilename(String vehicleReg, String type,
      String itemRef, String ext) {
    final parts = <String>[
      if (vehicleReg.isNotEmpty) vehicleReg,
      type,
      if (itemRef.isNotEmpty) itemRef,
      _uuid.v4(),
    ];
    return '${parts.join('_')}.$ext';
  }

  // ── GPS stamp ─────────────────────────────────────────────────────────────
  static Future<Uint8List?> _stampPhoto(Uint8List rawBytes, GeoTag geo) async {
    try {
      img.Image? image = img.decodeImage(rawBytes);
      if (image == null) return null;
      image = img.bakeOrientation(image);

      final w = image.width;
      final h = image.height;
      final scale = (w / 1080).clamp(1.0, 3.0);
      final bannerH = (120 * scale).round();

      for (int y = h - bannerH; y < h; y++) {
        for (int x = 0; x < w; x++) {
          final orig = image.getPixel(x, y);
          final r = ((orig.r * 0.2) + (13 * 0.8)).round().clamp(0, 255);
          final g = ((orig.g * 0.2) + (27 * 0.8)).round().clamp(0, 255);
          final b = ((orig.b * 0.2) + (62 * 0.8)).round().clamp(0, 255);
          image.setPixelRgba(x, y, r, g, b, 255);
        }
      }
      final stripH = (5 * scale).round();
      for (int y = h - stripH; y < h; y++) {
        for (int x = 0; x < w; x++) {
          image.setPixelRgba(x, y, 37, 99, 235, 255);
        }
      }

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, w.toDouble(), bannerH.toDouble()));

      final fs   = 13.0 * scale;
      final fsS  = 10.5 * scale;
      final pad  = 16.0 * scale;
      final lh   = fs * 1.65;

      _tx(canvas, 'CTS INSPECTION', Offset(pad, pad * 0.5),
          fontSize: fs, color: const Color(0xFF93C5FD), bold: true);
      _tx(canvas, geo.formattedDate,
          Offset(w - pad - geo.formattedDate.length * fsS * 0.6, pad * 0.5),
          fontSize: fsS, color: const Color(0xFFCBD5E1));
      _tx(canvas, 'GPS: ${geo.coordString}',
          Offset(pad, pad * 0.5 + lh),
          fontSize: fs, color: Colors.white, bold: true);
      _tx(canvas, geo.address,
          Offset(pad, pad * 0.5 + lh * 2),
          fontSize: fsS * 0.95, color: const Color(0xFFB8C8E8),
          maxWidth: (w - pad * 2).toDouble());

      final pic      = recorder.endRecording();
      final stampUi  = await pic.toImage(w, bannerH);
      final stampData = await stampUi.toByteData(
          format: ui.ImageByteFormat.png);
      if (stampData == null) return null;
      final stampImg = img.decodeImage(
          Uint8List.fromList(stampData.buffer.asUint8List()));
      if (stampImg == null) return null;
      img.compositeImage(image, stampImg, dstX: 0, dstY: h - bannerH);
      return Uint8List.fromList(img.encodeJpg(image, quality: 90));
    } catch (e) {
      debugPrint('Stamp error: $e');
      return null;
    }
  }

  static void _tx(Canvas canvas, String text, Offset offset,
      {required double fontSize, Color color = Colors.white,
       bool bold = false, double? maxWidth}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(
        color: color, fontSize: fontSize,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        fontFamily: 'monospace', letterSpacing: 0.3,
      )),
      textDirection: TextDirection.ltr, maxLines: 2,
    )..layout(maxWidth: maxWidth ?? double.infinity);
    tp.paint(canvas, offset);
  }
}
