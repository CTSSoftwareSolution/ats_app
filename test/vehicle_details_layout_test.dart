import 'package:ats_app/new_manual_flow/app_provider.dart';
import 'package:ats_app/new_manual_flow/auth_provider.dart';
import 'package:ats_app/new_manual_flow/new_model/vehicle_entry.dart';
import 'package:ats_app/new_manual_flow/new_model/vehicle_photos_model.dart';
import 'package:ats_app/new_manual_flow/new_screen/vehicle_details_screen.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Layout checks for VehicleDetailScreen: no overflow on small phones,
/// tablets and with enlarged text, plus the not-found state.
void main() {
  VehicleEntry longVehicle() => VehicleEntry(
        id: 'abcdef123456',
        regNo: 'MH12AB1234567',
        bookingId: 'BKG-2026-000012345678901',
        vehicleClass: 'Light Motor Vehicle Non-Transport',
        make: 'Mahindra & Mahindra Limited',
        model: 'Scorpio-N Z8L Diesel AT 4WD',
        fuelType: 'Petrol/CNG Hybrid',
        engineNo: 'ENG9876543210ABCDEF',
        chassisNo: 'MA1TA2NJ5P1234567',
        emissionNorms: 'BS-VI Phase 2 (RDE)',
        rtoDistrict: 'Pune Regional Transport Office',
        testDate: '06-10-2026',
        fitnessExpiry: '05-10-2027',
        customerName: 'Venkatanarasimharajuvaripeta Subramanyam',
        customerContact: '+91 98765 43210',
        laneName: 'Heavy Vehicle Lane 2',
        sections: [],
        photos: {
          for (final a in VehiclePhotoAngle.values.take(3))
            a: VehiclePhoto(
              angle: a,
              path: '/tmp/$a.jpg',
              latitude: 0,
              longitude: 0,
              address: '',
              capturedAt: DateTime(2026),
            ),
        },
      );

  Future<void> pump(WidgetTester tester, AppProvider app,
      {required double width, double textScale = 1.0}) async {
    tester.view.physicalSize = Size(width, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: app),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 2600),
              textScaler: TextScaler.linear(textScale),
            ),
            child: const VehicleDetailScreen(vehicleId: 'MH12AB1234567'),
          ),
        ),
      ),
    );
  }

  for (final width in [320.0, 360.0, 412.0, 600.0]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('vehicle details fit at ${width}dp, text x$scale', (tester) async {
        final app = AppProvider()..vehicles.add(longVehicle());
        await pump(tester, app, width: width, textScale: scale);
        expect(tester.takeException(), isNull);
        expect(find.text('MH12AB1234567'), findsOneWidget);
        expect(find.text('Vehicle photos'), findsOneWidget);
        // Post-inspection is locked until pre-inspection is done.
        expect(find.text('Complete the pre-inspection checks first'), findsOneWidget);
      });
    }
  }

  testWidgets('shows a not-found state instead of crashing', (tester) async {
    await pump(tester, AppProvider(), width: 360);
    expect(tester.takeException(), isNull);
    expect(find.text('Vehicle not found'), findsOneWidget);
  });
}
