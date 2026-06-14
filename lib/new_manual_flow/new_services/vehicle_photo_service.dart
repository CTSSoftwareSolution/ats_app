import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

import '../new_model/auth_model.dart';
import '../new_model/vehicle_photos_model.dart';
import 'location_service.dart';

class VehiclePhotoService {
  static final _picker = ImagePicker();
  static const _uuid = Uuid();

  static Future<VehiclePhoto?> capture(
      VehiclePhotoAngle angle, {
        AppConfig? config,
        String vehicleReg = '',
      }) async {
    // GPS starts in background before camera opens
    final geoFuture = LocationService.getCurrentLocation();

    // Open camera immediately
    final xfile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: config?.photoQuality ?? 92,
      maxWidth: 2560,
    );
    if (xfile == null) return null;

    // Read bytes and wait for GPS in parallel
    final rawBytesFuture = xfile.readAsBytes();
    final geo      = await geoFuture;
    final rawBytes = await rawBytesFuture;
    final capturedAt = geo.capturedAt;

    // Stamp GPS onto photo if configured
    Uint8List finalBytes;
    if (config?.stampGpsOnPhoto ?? true) {
      final stamped = await _stamp(rawBytes,
          angle:       angle,
          lat:         geo.latitude,
          lng:         geo.longitude,
          address:     geo.address,
          capturedAt:  capturedAt);
      finalBytes = stamped ?? rawBytes;
    } else {
      finalBytes = rawBytes;
    }

    // Keep bytes in memory only — no local file save
    return VehiclePhoto(
      angle:         angle,
      path:          'memory',   // no disk path
      bytes:         finalBytes,
      latitude:      geo.latitude,
      longitude:     geo.longitude,
      address:       geo.address,
      capturedAt:    capturedAt,
      savedToServer: false,
      storageNote:   'In memory — uploaded on submit',
    );
  }

  // ── GPS stamp ─────────────────────────────────────────────────────────────
  static Future<Uint8List?> _stamp(Uint8List rawBytes, {
    required VehiclePhotoAngle angle,
    required double lat,
    required double lng,
    required String address,
    required DateTime capturedAt,
  }) async {
    try {
      img.Image? image = img.decodeImage(rawBytes);
      if (image == null) return null;
      image = img.bakeOrientation(image);

      final w       = image.width;
      final h       = image.height;
      final scale   = (w / 1080).clamp(1.0, 3.0);
      final bannerH = (130 * scale).round();

      // Dark navy overlay at bottom
      for (int y = h - bannerH; y < h; y++) {
        for (int x = 0; x < w; x++) {
          final orig = image.getPixel(x, y);
          final r = ((orig.r * 0.15) + (13 * 0.85)).round().clamp(0, 255);
          final g = ((orig.g * 0.15) + (27 * 0.85)).round().clamp(0, 255);
          final b = ((orig.b * 0.15) + (62 * 0.85)).round().clamp(0, 255);
          image.setPixelRgba(x, y, r, g, b, 255);
        }
      }
      // Blue accent strip
      final stripH = (5 * scale).round();
      for (int y = h - stripH; y < h; y++) {
        for (int x = 0; x < w; x++) {
          image.setPixelRgba(x, y, 37, 99, 235, 255);
        }
      }

      final recorder  = ui.PictureRecorder();
      final canvas    = Canvas(recorder,
          Rect.fromLTWH(0, 0, w.toDouble(), bannerH.toDouble()));
      final fs        = 13.0 * scale;
      final fsS       = 10.5 * scale;
      final pad       = 16.0 * scale;
      final lh        = fs * 1.6;
      final label     = vehiclePhotoLabel(angle);
      final emoji     = vehiclePhotoEmoji(angle);

      _tx(canvas, '$emoji  ${label.toUpperCase()}',
          Offset(pad, pad * 0.4),
          fontSize: fs * 1.05, color: const Color(0xFFFBBF24), bold: true);

      final dateStr =
          '${capturedAt.day.toString().padLeft(2, '0')}-'
          '${capturedAt.month.toString().padLeft(2, '0')}-'
          '${capturedAt.year}  '
          '${capturedAt.hour.toString().padLeft(2, '0')}:'
          '${capturedAt.minute.toString().padLeft(2, '0')}';
      _tx(canvas, dateStr,
          Offset(w - pad - dateStr.length * fsS * 0.6, pad * 0.4),
          fontSize: fsS, color: const Color(0xFFCBD5E1));

      _tx(canvas, 'CTS VEHICLE INSPECTION',
          Offset(pad, pad * 0.4 + lh * 0.9),
          fontSize: fsS, color: const Color(0xFF93C5FD), bold: true);

      _tx(canvas,
          'GPS: ${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}',
          Offset(pad, pad * 0.4 + lh * 1.8),
          fontSize: fs, color: Colors.white, bold: true);

      _tx(canvas, address,
          Offset(pad, pad * 0.4 + lh * 2.7),
          fontSize: fsS * 0.95,
          color: const Color(0xFFB8C8E8),
          maxWidth: (w - pad * 2).toDouble());

      final pic       = recorder.endRecording();
      final stampUi   = await pic.toImage(w, bannerH);
      final stampData = await stampUi.toByteData(
          format: ui.ImageByteFormat.png);
      if (stampData == null) return null;
      final overlay   = img.decodeImage(
          Uint8List.fromList(stampData.buffer.asUint8List()));
      if (overlay == null) return null;
      img.compositeImage(image, overlay, dstX: 0, dstY: h - bannerH);
      return Uint8List.fromList(img.encodeJpg(image, quality: 90));
    } catch (e) {
      debugPrint('[VehiclePhoto] Stamp error: $e');
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
