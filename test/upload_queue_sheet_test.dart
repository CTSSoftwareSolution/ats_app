import 'package:ats_app/Data/model/response_model/vehicle_parts_res_model.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/media_upload_tracker.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_queue_sheet.dart';
import 'package:ats_app/image_processing/MediaPicker/file_provider.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// The upload queue sheet lists every captured photo/video with its status,
/// stays readable with many items, and never overflows.
void main() {
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
      type: 2,
      questionId: 14,
    ),
    PartsDataModel(
      id: 5,
      vehiclePartName: 'Speed governor seal',
      type: 1,
      questionId: 15,
    ),
    PartsDataModel(id: 6, vehiclePartName: 'Wipers', type: 1, questionId: 16),
  ];

  Future<void> openSheet(
    WidgetTester tester, {
    required double width,
    double textScale = 1.0,
    bool failedOnly = false,
  }) async {
    final files = FileProvider();
    // Part 0: photo + video captured; parts 1, 2, 4: photo; part 3: video;
    // part 5: nothing captured (must not be listed).
    files.mediaFile
      ..add(
        MediaFile()
          ..image = XFile('a.jpg')
          ..video = XFile('a.mp4'),
      )
      ..add(MediaFile()..image = XFile('b.jpg'))
      ..add(MediaFile()..image = XFile('c.jpg'))
      ..add(MediaFile()..video = XFile('d.mp4'))
      ..add(MediaFile()..image = XFile('e.jpg'))
      ..add(MediaFile());
    final tracker = MediaUploadTracker()
      ..set(0, false, SlotUploadState.uploaded, path: 'a.jpg')
      ..set(0, true, SlotUploadState.failed, path: 'a.mp4')
      ..set(1, false, SlotUploadState.uploading, path: 'b.jpg')
      ..set(2, false, SlotUploadState.uploaded, path: 'c.jpg')
      ..set(3, true, SlotUploadState.failed, path: 'd.mp4')
      ..set(4, false, SlotUploadState.uploaded, path: 'e.jpg');

    tester.view.physicalSize = Size(width, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: files,
        child: MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 2400),
              textScaler: TextScaler.linear(textScale),
            ),
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () => showUploadQueueSheet(
                      screenContext: context,
                      parts: parts,
                      tracker: tracker,
                      failedOnly: failedOnly,
                    ),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    // Fixed pumps: the uploading spinners animate forever, so the tree
    // never "settles".
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  for (final width in [320.0, 360.0, 412.0, 600.0]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('upload sheet fits at ${width}dp, text x$scale', (
        tester,
      ) async {
        await openSheet(tester, width: width, textScale: scale);
        expect(tester.takeException(), isNull);
        expect(find.text('Uploads'), findsOneWidget);
        expect(find.text('3 of 6 uploaded · 1 in progress'), findsOneWidget);
        // 6 captured slots listed; the uncaptured part is not.
        expect(find.text('Wipers'), findsNothing);
        expect(find.text('Retry'), findsNWidgets(2));
        expect(find.text('Retry all'), findsOneWidget);
      });
    }
  }

  testWidgets('filter shows only failed uploads', (tester) async {
    await openSheet(tester, width: 360);
    await tester.tap(find.text('Failed 2'));
    await tester.pump();
    expect(find.text('Head lamp'), findsNothing); // uploading
    expect(find.text('Tail lamp'), findsOneWidget); // failed video
    expect(find.text('Upload failed'), findsNWidgets(2));
  });

  testWidgets('"Review failed" opens on the failed filter', (tester) async {
    await openSheet(tester, width: 360, failedOnly: true);
    expect(find.text('Head lamp'), findsNothing); // uploading
    expect(find.text('Tail lamp'), findsOneWidget); // failed video
    expect(find.text('Upload failed'), findsNWidgets(2));
  });
}
