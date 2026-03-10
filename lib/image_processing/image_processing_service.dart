
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:native_exif/native_exif.dart';
import 'package:provider/provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:image/image.dart' as img;

import '../Presentation/provider/vehicle_class_provider.dart';
import '../location/location_provider.dart';

class ImageProcessingService {

  const ImageProcessingService._();

  static Future<String> processOverlayImage({required XFile picture, required BuildContext context}) async {
    final location = Provider.of<LocationProvider>(context, listen: false);
    final vehicleClass = Provider.of<VehicleClassProvider>(context, listen: false);
    final lat = location.currentPosition?.latitude ?? 0.0;
    final lng = location.currentPosition?.longitude ?? 0.0;
    final vehicleNo = vehicleClass.selectedClass!.registrationNo;

    final file = File(picture.path);
    final now = DateTime.now();
    final rawText = "Vehicle No: $vehicleNo\nLat: $lat, Lng: $lng\nDate: $now";
    final displayText = rawText.split('\n').map((line) => _wrapText(line, 32)).join('\n');

    final bytes = await file.readAsBytes();
    final src = img.decodeImage(bytes)!;

    _drawTextOverlay(src, displayText);

    final overlayPath = '${file.parent.path}/overlay_${now.millisecondsSinceEpoch}.jpg';
    await File(overlayPath).writeAsBytes(img.encodeJpg(src, quality: 92));
    return overlayPath;
  }

  static void _drawTextOverlay(img.Image src, String displayText) {
    const int lineHeight = 23;
    const int padX = 12;
    const int padY = 10;
    const int lineSpacing = 4;
    const int approxCharWidth = 13;
    const int maxCharsPerLine = 32;

    final lines = displayText.split('\n');
    final bgWidth = maxCharsPerLine * approxCharWidth + padX * 2;
    final bgHeight = lines.length * lineHeight + padY * 2 + (lines.length - 1) * lineSpacing;
    const int bgX = 16;
    final int bgY = src.height - bgHeight - padY - 16;

    img.fillRect(
      src,
      x1: bgX,
      y1: bgY,
      x2: bgX + bgWidth,
      y2: bgY + bgHeight,
      color: img.ColorRgba8(30, 30, 30, 190),
    );

    for (int i = 0; i < lines.length; i++) {
      img.drawString(
        src,
        lines[i],
        font: img.arial24,
        x: bgX + padX,
        y: bgY + padY + i * (lineHeight + lineSpacing),
        color: img.ColorRgba8(255, 255, 255, 255),
      );
    }
  }

  static Future<void> writeExifMetadata(String overlayPath, {
    required double lat,
    required double lng,
    required Map<String, dynamic> overlayData,
  }) async {
    final overlayText = jsonEncode(overlayData);
    final exif = await Exif.fromPath(overlayPath);
    await exif.writeAttributes({
      'GPSLatitude': '$lat',
      'GPSLongitude': '$lng',
      'UserComment': overlayText,
      'ImageDescription': overlayText,
    });
    await exif.close();
  }

  static Future<void> saveToGallery(String overlayPath, String fileName) async {
    if (!kDebugMode) return;
    final result = await SaverGallery.saveFile(
      filePath: overlayPath,
      androidRelativePath: 'Pictures/MyApp Images',
      fileName: fileName,
      skipIfExists: false,
    );
    debugPrint(result.isSuccess ? 'Saved to gallery' : 'Not saved: ${result.errorMessage}');
  }

  static String _wrapText(String text, int maxChars) {
    final words = text.split(' ');
    final buffer = StringBuffer();
    int lineLength = 0;
    for (final word in words) {
      if (lineLength + word.length > maxChars) {
        buffer.write('\n');
        lineLength = 0;
      }
      buffer.write(word);
      buffer.write(' ');
      lineLength += word.length + 1;
    }
    return buffer.toString().trimRight();
  }

}