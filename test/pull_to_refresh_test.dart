import 'dart:async';

import 'package:ats_app/Data/model/request_model/ai_result_req_model.dart';
import 'package:ats_app/Data/model/request_model/manual_inspection_request.dart';
import 'package:ats_app/Data/model/request_model/vehicle_class_req_model.dart';
import 'package:ats_app/Data/model/response_model/ai_result_response.dart';
import 'package:ats_app/Data/model/response_model/manual_inspection_list_model.dart';
import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:ats_app/Domain/entities/ai_result_entity.dart';
import 'package:ats_app/Domain/entities/lane_list_entity.dart';
import 'package:ats_app/Domain/entities/manual_inspection_entity.dart';
import 'package:ats_app/Domain/entities/vehicle_class_entity.dart';
import 'package:ats_app/Domain/repositories/ai_result_repository.dart';
import 'package:ats_app/Domain/repositories/ai_update_result_repository.dart';
import 'package:ats_app/Domain/repositories/lane_list_repository.dart';
import 'package:ats_app/Domain/repositories/manual_inspection_repository.dart';
import 'package:ats_app/Domain/repositories/vehicle_class_repository.dart';
import 'package:ats_app/Domain/usecases/ai_result_usecases.dart';
import 'package:ats_app/Domain/usecases/ai_update_result_usecases.dart';
import 'package:ats_app/Domain/usecases/lane_list_usecase.dart';
import 'package:ats_app/Domain/usecases/manual_inspection_list_usecase.dart';
import 'package:ats_app/Domain/usecases/vehicle_class_usecases.dart';
import 'package:ats_app/Presentation/provider/ai_result_provider.dart';
import 'package:ats_app/Presentation/provider/ai_update_result_provider.dart';
import 'package:ats_app/Presentation/provider/lane_list_provider.dart';
import 'package:ats_app/Presentation/provider/manual_inspection_list_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:ats_app/Presentation/screens/ai_result/ai_result_screen.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_screen.dart';
import 'package:ats_app/Presentation/screens/result_page/result_screen.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pull-to-refresh on Home, Result and AI Result:
/// pull → indicator → existing provider API → data updated → indicator stops,
/// on success and on failure, with no duplicate requests while one runs.

/// Every API call returns a future the test completes (success or error).
class _Calls<T> {
  final List<Completer<T>> pending = [];
  int get count => pending.length;
  Future<T> next() {
    final c = Completer<T>();
    pending.add(c);
    return c.future;
  }
}

class _VehicleRepo implements VehicleClassRepository {
  final calls = _Calls<VehicleClassEntity>();
  @override
  Future<VehicleClassEntity> vehicleClassApi(VehicleClassReqModel m) =>
      calls.next();
}

class _LaneRepo implements LaneListRepository {
  @override
  Future<LaneListEntity> laneListApi() async => LaneListEntity();
}

class _ResultRepo implements ManualInspectionRepository {
  final calls = _Calls<ManualInspectionEntity>();
  @override
  Future<ManualInspectionEntity> getManualInspectionRepository(
    ManualInspectionRequest r,
  ) => calls.next();
}

class _AiRepo implements AiResultRepository {
  final calls = _Calls<AiResultEntity>();
  @override
  Future<AiResultEntity> aiResultDetails(AiResultReqModel r) => calls.next();
}

class _NoUpdateRepo implements AiUpdateResultRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

VehicleClassEntity _appointments(String reg) => VehicleClassEntity(
  status: true,
  data: ClassDataModel(
    totalRecords: 1,
    appointments: [Appointments(registrationNo: reg)],
  ),
);

ManualInspectionEntity _results(String reg) => ManualInspectionEntity(
  status: true,
  data: ManualInsData(
    totalRecords: 1,
    appointments: [
      ManualLisAppointments(registrationNo: reg, manualStatus: 'Pass'),
    ],
  ),
);

AiResultEntity _aiResult(String question) => AiResultEntity(
  success: true,
  data: [
    ResultData(
      id: 1,
      labelId: 1,
      questionText: question,
      aiResponse: AiResponse(overallResult: 'Pass'),
    ),
  ],
);

/// Drags the list down far enough to trigger the RefreshIndicator.
Future<void> _pull(WidgetTester tester) async {
  final list = find
      .descendant(
        of: find.byType(RefreshIndicator),
        matching: find.byType(Scrollable),
      )
      .first;
  await tester.fling(list, const Offset(0, 400), 1200);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1)); // indicator snaps into refresh
}

bool _refreshing(WidgetTester tester) =>
    find.byType(RefreshProgressIndicator).evaluate().isNotEmpty;

Widget _app(List<ChangeNotifierProvider> providers, Widget home) =>
    MultiProvider(
      providers: providers,
      child: MaterialApp(
        theme: AppTheme.light,
        builder: EasyLoading.init(),
        home: home,
      ),
    );

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({Preferences.name: 'Inspector'});
    await Preferences.setPreferences();
  });

  testWidgets(
    'Home: pull refreshes once, updates data, stops on success and failure',
    (tester) async {
      final repo = _VehicleRepo();
      final vehicles = VehicleClassProvider(
        vehicleClassUseCases: VehicleClassUseCases(
          vehicleClassRepository: repo,
        ),
      );
      await tester.pumpWidget(
        _app([
          ChangeNotifierProvider<VehicleClassProvider>.value(value: vehicles),
          ChangeNotifierProvider<LaneListProvider>(
            create: (_) => LaneListProvider(
              laneListUseCase: LaneListUseCase(laneListRepository: _LaneRepo()),
            ),
          ),
        ], const HomeScreen()),
      );

      // Initial load (existing initState call).
      expect(repo.calls.count, 1);
      repo.calls.pending[0].complete(_appointments('MH01AA1111'));
      await tester.pumpAndSettle();
      expect(find.text('MH01AA1111'), findsOneWidget);

      // Pull → indicator → one API call.
      await _pull(tester);
      expect(_refreshing(tester), isTrue);
      expect(repo.calls.count, 2);

      // A second pull while refreshing does not call the API again.
      await _pull(tester);
      expect(repo.calls.count, 2);

      // Success: new data shown, indicator stops.
      repo.calls.pending[1].complete(_appointments('MH02BB2222'));
      await tester.pumpAndSettle();
      expect(_refreshing(tester), isFalse);
      expect(find.text('MH02BB2222'), findsOneWidget);

      // Failure: indicator still stops.
      await _pull(tester);
      expect(repo.calls.count, 3);
      repo.calls.pending[2].completeError(Exception('network down'));
      await tester.pumpAndSettle();
      expect(_refreshing(tester), isFalse);
    },
  );

  testWidgets('Home: scrolling to the end loads exactly one next page', (
    tester,
  ) async {
    final repo = _VehicleRepo();
    final vehicles = VehicleClassProvider(
      vehicleClassUseCases: VehicleClassUseCases(vehicleClassRepository: repo),
    );
    await tester.pumpWidget(
      _app([
        ChangeNotifierProvider<VehicleClassProvider>.value(value: vehicles),
        ChangeNotifierProvider<LaneListProvider>(
          create: (_) => LaneListProvider(
            laneListUseCase: LaneListUseCase(laneListRepository: _LaneRepo()),
          ),
        ),
      ], const HomeScreen()),
    );

    repo.calls.pending[0].complete(
      VehicleClassEntity(
        status: true,
        data: ClassDataModel(
          totalRecords: 40,
          appointments: [
            for (var i = 0; i < 20; i++)
              Appointments(registrationNo: 'MH01AA${1000 + i}'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(repo.calls.count, 1);

    // Many scroll updates near the end (as during a real fling) → still
    // exactly one page request.
    final list = find
        .descendant(
          of: find.byType(RefreshIndicator),
          matching: find.byType(Scrollable),
        )
        .first;
    ScrollPosition position() => tester.state<ScrollableState>(list).position;
    for (var i = 0; i < 12; i++) {
      position().jumpTo(position().maxScrollExtent - 100 + i * 5);
      await tester.pump();
    }
    expect(repo.calls.count, 2);

    repo.calls.pending[1].complete(
      VehicleClassEntity(
        status: true,
        data: ClassDataModel(
          appointments: [Appointments(registrationNo: 'MH09ZZ9999')],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    position().jumpTo(position().maxScrollExtent);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // The appended page is shown, and reaching the new end asks for the
    // following page exactly once (left pending, so its spinner keeps
    // animating – hence fixed pumps instead of pumpAndSettle).
    expect(vehicles.vehicleClassEntity!.data!.appointments!.length, 21);
    expect(find.text('MH09ZZ9999', skipOffstage: false), findsOneWidget);
    expect(repo.calls.count, 3);
  });

  testWidgets(
    'Result: pull refreshes once, updates data, stops on success and failure',
    (tester) async {
      final repo = _ResultRepo();
      final results = ManualInspectionListProvider(
        manualInspectionListUseCase: ManualInspectionListUseCase(
          manualInspectionRepository: repo,
        ),
      );
      await tester.pumpWidget(
        _app([
          ChangeNotifierProvider<ManualInspectionListProvider>.value(
            value: results,
          ),
        ], const ResultScreen()),
      );

      expect(repo.calls.count, 1);
      repo.calls.pending[0].complete(_results('MH03CC3333'));
      await tester.pumpAndSettle();
      expect(find.text('MH03CC3333'), findsOneWidget);

      await _pull(tester);
      expect(_refreshing(tester), isTrue);
      expect(repo.calls.count, 2);
      await _pull(tester);
      expect(repo.calls.count, 2);

      repo.calls.pending[1].complete(_results('MH04DD4444'));
      await tester.pumpAndSettle();
      expect(_refreshing(tester), isFalse);
      expect(find.text('MH04DD4444'), findsOneWidget);

      await _pull(tester);
      expect(repo.calls.count, 3);
      repo.calls.pending[2].completeError(Exception('timeout'));
      await tester.pumpAndSettle();
      expect(_refreshing(tester), isFalse);
    },
  );

  testWidgets(
    'AI Result: pull refreshes once, updates data, stops on success and failure',
    (tester) async {
      final repo = _AiRepo();
      final ai = AiResultProvider(
        aiResultUseCases: AiResultUseCases(resultRepository: repo),
      )..aiResultEntity = _aiResult('Question before refresh?');
      await tester.pumpWidget(
        _app([
          ChangeNotifierProvider<AiResultProvider>.value(value: ai),
          ChangeNotifierProvider<VehicleClassProvider>(
            create: (_) => VehicleClassProvider(
              vehicleClassUseCases: VehicleClassUseCases(
                vehicleClassRepository: _VehicleRepo(),
              ),
            ),
          ),
          ChangeNotifierProvider<AiUpdateResultProvider>(
            create: (_) => AiUpdateResultProvider(
              resultUseCases: AiUpdateResultUseCases(
                aiUpdateResultRepository: _NoUpdateRepo(),
              ),
            ),
          ),
        ], const AiResultScreen()),
      );
      await tester.pumpAndSettle();
      expect(repo.calls.count, 0); // result was loaded before the screen opened

      await _pull(tester);
      expect(_refreshing(tester), isTrue);
      expect(repo.calls.count, 1);
      // List stays on screen under the indicator (no full-screen loader).
      expect(find.text('Question before refresh?'), findsOneWidget);
      await _pull(tester);
      expect(repo.calls.count, 1);

      repo.calls.pending[0].complete(_aiResult('Question after refresh?'));
      await tester.pumpAndSettle();
      expect(_refreshing(tester), isFalse);
      expect(find.text('Question after refresh?'), findsOneWidget);

      await _pull(tester);
      expect(repo.calls.count, 2);
      repo.calls.pending[1].completeError(Exception('server error'));
      await tester.pumpAndSettle();
      expect(_refreshing(tester), isFalse);
      // Existing failure behaviour: the error state with Retry is shown.
      expect(find.text('Unable to load result'), findsOneWidget);
    },
  );
}
