import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/appointment_card_shimmer.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/build_header_home.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/home_list_summary.dart';
import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_screen_item.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Layout checks for the Home screen widgets: they must render without
/// overflow on small phones, tablets and with enlarged text. Flutter reports
/// any RenderFlex overflow as a test failure.
void main() {
  final longAppointment = Appointments(
    registrationNo: 'MH12AB1234567',
    bookingId: 'BKG-2026-000012345678901',
    appointmentDate: '2026-10-06T10:30:00',
    vehicleClass: 'Light Motor Vehicle Non-Transport',
    vehicleCategory: 'LMV-NT',
    fuelType: 'Petrol/CNG Hybrid',
    make: 'Mahindra & Mahindra Limited',
    model: 'Scorpio-N Z8L Diesel AT 4WD',
    mfgYear: '2024',
    manualPreInspectionStatus: 'Re-inspection Required',
    machineInspectonStatus: 'Fail',
  );
  final emptyAppointment = Appointments();

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    required double width,
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(width, 900),
            textScaler: TextScaler.linear(textScale),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
    // Let shimmer animations run a frame.
    await tester.pump(const Duration(milliseconds: 100));
  }

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      Preferences.name: 'Venkatanarasimharajuvaripeta Subramanyam',
      Preferences.location:
          'Regional Transport Office Automated Testing Station, Pune',
    });
    await Preferences.setPreferences();
  });

  for (final width in [320.0, 360.0, 412.0, 600.0]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('appointment card fits at ${width}dp, text x$scale', (
        tester,
      ) async {
        await pump(
          tester,
          Column(
            children: [
              VehicleClassScreenItem(
                classDataModel: longAppointment,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              VehicleClassScreenItem(
                classDataModel: emptyAppointment,
                onTap: () {},
              ),
            ],
          ),
          width: width,
          textScale: scale,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Inspect'), findsNWidgets(2));
        expect(find.text('Not started'), findsNWidgets(2));
      });

      testWidgets(
        'header, summary and shimmer fit at ${width}dp, text x$scale',
        (tester) async {
          await pump(
            tester,
            const Column(
              children: [
                BuildHeaderHome(),
                HomeListSummary(
                  totalRecords: 12840,
                  loadedCount: 20,
                  category: 'Heavy Goods Vehicle',
                  search: 'MH12 very long search query text',
                ),
                AppointmentCardShimmer(),
              ],
            ),
            width: width,
            textScale: scale,
          );
          expect(tester.takeException(), isNull);
          expect(
            find.text('Hello, Venkatanarasimharajuvaripeta'),
            findsOneWidget,
          );
        },
      );
    }
  }

  testWidgets('appointment card fits at 320dp with text x1.5', (tester) async {
    await pump(
      tester,
      VehicleClassScreenItem(classDataModel: longAppointment, onTap: () {}),
      width: 320,
      textScale: 1.5,
    );
    expect(tester.takeException(), isNull);
  });
}
