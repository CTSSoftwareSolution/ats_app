import 'package:ats_app/Data/model/request_model/manual_inspection_request.dart';
import 'package:ats_app/Data/model/response_model/manual_inspection_list_model.dart';
import 'package:ats_app/Domain/entities/manual_inspection_entity.dart';
import 'package:ats_app/Domain/repositories/manual_inspection_repository.dart';
import 'package:ats_app/Domain/usecases/manual_inspection_list_usecase.dart';
import 'package:ats_app/Presentation/provider/manual_inspection_list_provider.dart';
import 'package:ats_app/Presentation/screens/result_page/result_screen.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Result tab: renders the API values unchanged, fits small screens and
/// large text, and keeps Retest on failed results only.

class FakeResults implements ManualInspectionRepository {
  final List<ManualLisAppointments> items;
  FakeResults(this.items);

  @override
  Future<ManualInspectionEntity> getManualInspectionRepository(
    ManualInspectionRequest request,
  ) async => ManualInspectionEntity(
    status: true,
    data: ManualInsData(
      totalRecords: 134,
      pageNo: 1,
      pageSize: 20,
      appointments: List.of(items),
    ),
  );
}

final sampleResults = [
  ManualLisAppointments(
    registrationNo: 'MH12AB1234567',
    bookingId: 'BKG-2026-000012345678901',
    appointmentDate: '2026-10-06T10:30:00',
    vehicleClass: 'Light Motor Vehicle Non-Transport',
    make: 'Mahindra & Mahindra Limited',
    fuelType: 'Petrol/CNG Hybrid',
    manualStatus: 'Fail',
  ),
  ManualLisAppointments(
    registrationNo: 'MH14CD5678',
    bookingId: 'BKG-104523',
    appointmentDate: '2026-10-06T11:15:00',
    vehicleClass: 'HMV',
    make: 'Tata',
    fuelType: 'Diesel',
    manualStatus: 'Pass',
  ),
  ManualLisAppointments(registrationNo: 'MH01EF9012', manualStatus: null),
];

Future<void> pumpResults(
  WidgetTester tester, {
  required double width,
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = Size(width, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final provider = ManualInspectionListProvider(
    manualInspectionListUseCase: ManualInspectionListUseCase(
      manualInspectionRepository: FakeResults(sampleResults),
    ),
  );
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(width, 2200),
            textScaler: TextScaler.linear(textScale),
          ),
          child: const ResultScreen(),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  emptyStateTests();

  for (final width in [320.0, 360.0, 412.0, 600.0]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('result list fits at ${width}dp, text x$scale', (
        tester,
      ) async {
        await pumpResults(tester, width: width, textScale: scale);
        expect(tester.takeException(), isNull);
        expect(find.text('Inspection results'), findsOneWidget);
        expect(find.text('134'), findsOneWidget);
        expect(find.text('Booking ID BKG-104523'), findsOneWidget);
        // Same badge values as before: empty status → "Pending".
        expect(find.text('Fail'), findsOneWidget);
        expect(find.text('Pass'), findsOneWidget);
        expect(find.text('Pending'), findsOneWidget);
        // Retest only on the failed result.
        expect(find.text('Retest'), findsOneWidget);
      });
    }
  }
}

/// Result tab empty states: each offers the quickest way back to a list.
void emptyStateTests() {
  Future<ManualInspectionListProvider> pumpEmpty(
    WidgetTester tester, {
    String search = '',
  }) async {
    tester.view.physicalSize = const Size(360, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final provider = ManualInspectionListProvider(
      manualInspectionListUseCase: ManualInspectionListUseCase(
        manualInspectionRepository: FakeResults(const []),
      ),
    );
    provider.searchController.text = search;
    provider.searchValue = search;
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(theme: AppTheme.light, home: const ResultScreen()),
      ),
    );
    await tester.pumpAndSettle();
    return provider;
  }

  testWidgets('no results: Retry', (tester) async {
    await pumpEmpty(tester);
    expect(find.text('No results to show'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('no matching search: Clear search empties the box', (
    tester,
  ) async {
    final provider = await pumpEmpty(tester, search: 'MH99');
    expect(find.text('No matching results'), findsOneWidget);
    await tester.tap(find.text('Clear search'));
    await tester.pumpAndSettle();
    expect(provider.searchController.text, isEmpty);
  });
}
