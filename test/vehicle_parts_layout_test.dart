import 'package:ats_app/Data/model/response_model/vehicle_parts_res_model.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/capture_status.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/media_upload_tracker.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_responsive_item.dart';
import 'package:ats_app/image_processing/MediaPicker/file_provider.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// The media capture card must show the five capture states clearly and
/// never overflow on small phones, tablets or with enlarged text.
void main() {
  group('CaptureStatus', () {
    test('slot status follows file + upload state', () {
      expect(CaptureStatus.ofSlot(hasFile: false), CaptureStatus.notCaptured);
      expect(CaptureStatus.ofSlot(hasFile: true), CaptureStatus.captured);
      expect(
        CaptureStatus.ofSlot(hasFile: true, upload: SlotUploadState.uploading),
        CaptureStatus.uploading,
      );
      expect(
        CaptureStatus.ofSlot(hasFile: true, upload: SlotUploadState.uploaded),
        CaptureStatus.uploaded,
      );
      expect(
        CaptureStatus.ofSlot(hasFile: true, upload: SlotUploadState.failed),
        CaptureStatus.failed,
      );
    });

    test('part status surfaces what needs attention first', () {
      const s = CaptureStatus.values;
      expect(CaptureStatus.combine([s[3], s[4]]), CaptureStatus.failed);
      expect(CaptureStatus.combine([s[3], s[2]]), CaptureStatus.uploading);
      expect(CaptureStatus.combine([s[3], s[0]]), CaptureStatus.notCaptured);
      expect(CaptureStatus.combine([s[3], s[1]]), CaptureStatus.captured);
      expect(CaptureStatus.combine([s[3], s[3]]), CaptureStatus.uploaded);
    });
  });

  // Part 0: photo + video, nothing captured. Parts 1-4: photo captured, then
  // no upload / uploading / uploaded / failed.
  final parts = [
    PartsDataModel(
      id: 1,
      vehiclePartName: 'Front number plate and registration mark lighting',
      type: 3,
      questionId: 11,
    ),
    PartsDataModel(
      id: 2,
      vehiclePartName: 'Head lamp',
      type: 1,
      questionId: 12,
    ),
    PartsDataModel(
      id: 3,
      vehiclePartName: 'Rear view mirror (left)',
      type: 1,
      questionId: 13,
    ),
    PartsDataModel(
      id: 4,
      vehiclePartName: 'Tail lamp',
      type: 1,
      questionId: 14,
    ),
    PartsDataModel(
      id: 5,
      vehiclePartName: 'Speed governor seal',
      type: 1,
      questionId: 15,
    ),
  ];

  Future<void> pump(
    WidgetTester tester, {
    required double width,
    double textScale = 1.0,
  }) async {
    final files = FileProvider();
    files.mediaFile.add(MediaFile());
    for (var i = 1; i < parts.length; i++) {
      files.mediaFile.add(
        MediaFile()..image = XFile('assets/default-image.png'),
      );
    }
    final tracker = MediaUploadTracker()
      ..set(2, false, SlotUploadState.uploading, path: 'a')
      ..set(3, false, SlotUploadState.uploaded, path: 'b')
      ..set(4, false, SlotUploadState.failed, path: 'c');

    tester.view.physicalSize = Size(width, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: files,
        child: MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 3200),
              textScaler: TextScaler.linear(textScale),
            ),
            child: Scaffold(
              body: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: parts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => VehiclePartsResponsiveItem(
                  item: parts[i],
                  allIndex: i,
                  isTablet: false,
                  tracker: tracker,
                  totalParts: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  for (final width in [320.0, 360.0, 412.0, 600.0]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('capture cards fit at ${width}dp, text x$scale', (
        tester,
      ) async {
        await pump(tester, width: width, textScale: scale);
        expect(tester.takeException(), isNull);
        // Each state is spelled out (part badge + slot badge for captured ones).
        expect(find.text('Not captured'), findsOneWidget);
        expect(find.text('Captured'), findsNWidgets(2));
        expect(find.text('Uploading'), findsNWidgets(2));
        expect(find.text('Uploaded'), findsNWidgets(2));
        expect(find.text('Upload failed'), findsNWidgets(2));
        expect(find.text('Retry'), findsOneWidget);
        expect(find.text('PART 1 OF 12'), findsOneWidget);
      });
    }
  }
}
