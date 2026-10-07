import 'package:ats_app/Data/model/response_model/ai_result_response.dart';
import 'package:ats_app/Domain/entities/ai_result_entity.dart';
import 'package:ats_app/Domain/repositories/ai_result_repository.dart';
import 'package:ats_app/Domain/repositories/ai_update_result_repository.dart';
import 'package:ats_app/Domain/usecases/ai_result_usecases.dart';
import 'package:ats_app/Domain/usecases/ai_update_result_usecases.dart';
import 'package:ats_app/Presentation/provider/ai_result_provider.dart';
import 'package:ats_app/Presentation/provider/ai_update_result_provider.dart';
import 'package:ats_app/Presentation/screens/ai_result/ai_result_screen.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// AI Result screen: shows the API content unchanged, fits small screens and
/// large text, and tapping a question opens the change sheet for that
/// question only.

class NoResultRepo implements AiResultRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class NoUpdateRepo implements AiUpdateResultRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

AiResultProvider resultProvider() {
  final p = AiResultProvider(
    aiResultUseCases: AiResultUseCases(resultRepository: NoResultRepo()),
  );
  p.aiResultEntity = AiResultEntity(
    success: true,
    data: [
      ResultData(
        id: 1,
        labelId: 11,
        documentId: 1,
        questionText: 'Are both head lamps working on high and low beam?',
        aiResponse: AiResponse(
          overallResult: 'Pass',
          analysis: {
            'headlights_detected': true,
            'numberOfHeadlights': 2,
            'processing_time_sec': 1.2, // hidden key
            'request_id': 'req-123', // hidden key
            'model_version': 'v4.2', // hidden key
          },
        ),
      ),
      ResultData(
        id: 2,
        labelId: 12,
        documentId: 1,
        questionText:
            'Is the rear registration plate clearly visible and correctly mounted?',
        aiResponse: AiResponse(
          overallResult: 'Fail',
          analysis: {'plate_visible': false, 'confidence': 'Low'},
        ),
        aiRemark: 'Plate is bent',
      ),
      ResultData(
        id: 3,
        labelId: 13,
        documentId: 1,
        questionText: 'Is the windscreen free of cracks?',
        aiResponse: AiResponse(overallResult: 'Pending'),
      ),
      ResultData(
        id: 4,
        labelId: 14,
        documentId: 1,
        questionText: 'Are the wipers working?',
      ),
    ],
  );
  return p;
}

Future<void> pumpScreen(
  WidgetTester tester, {
  required double width,
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = Size(width, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: resultProvider()),
        ChangeNotifierProvider(
          create: (_) => AiUpdateResultProvider(
            resultUseCases: AiUpdateResultUseCases(
              aiUpdateResultRepository: NoUpdateRepo(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(width, 2200),
            textScaler: TextScaler.linear(textScale),
          ),
          child: const AiResultScreen(),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  verdictTests();

  for (final width in [320.0, 360.0, 412.0, 600.0]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('AI result fits at ${width}dp, text x$scale', (tester) async {
        await pumpScreen(tester, width: width, textScale: scale);
        expect(tester.takeException(), isNull);
        // Content shown as returned by the API.
        expect(
          find.text('Are both head lamps working on high and low beam?'),
          findsOneWidget,
        );
        expect(find.text('INSPECTION QUESTION 2 OF 4'), findsOneWidget);
        expect(find.text('Change result'), findsNWidgets(4));
        // Overall verdict first: one check failed.
        expect(find.text('OVERALL AI RESULT'), findsOneWidget);
        expect(find.text('1 of 4 checks failed'), findsOneWidget);
        // Statuses: PASS, FAIL (card + verdict), PENDING, not available.
        expect(find.text('PASS'), findsOneWidget);
        expect(find.text('FAIL'), findsNWidgets(2));
        expect(find.text('PENDING'), findsOneWidget);
        expect(
          find.text('AI result not available').hitTestable(),
          findsOneWidget,
        );
        expect(find.text('Remark: Plate is bent'), findsOneWidget);
      });
    }
  }

  testWidgets('result details expand per question with the same rows', (
    tester,
  ) async {
    await pumpScreen(tester, width: 360);
    List<CrossFadeState> states() => find
        .byType(AnimatedCrossFade)
        .evaluate()
        .map((e) => (e.widget as AnimatedCrossFade).crossFadeState)
        .toList();
    expect(states(), everyElement(CrossFadeState.showFirst)); // collapsed

    await tester.tap(find.text('RESULT DETAILS').first);
    await tester.pump(const Duration(milliseconds: 300));
    expect(states(), [
      CrossFadeState.showSecond,
      CrossFadeState.showFirst,
      CrossFadeState.showFirst,
      CrossFadeState.showFirst,
    ]);
    expect(find.text('Headlights detected'), findsWidgets);
    expect(find.text('Number of headlights'), findsWidgets);
    // Technical metadata is never shown.
    expect(find.text('Processing time sec'), findsNothing);
    expect(find.text('Request id'), findsNothing);
    expect(find.text('Model version'), findsNothing);
    expect(find.textContaining('req-123'), findsNothing);
  });

  testWidgets('tapping a question opens the change sheet for that question only', (
    tester,
  ) async {
    await pumpScreen(tester, width: 360);
    await tester.tap(
      find.text(
        'Is the rear registration plate clearly visible and correctly mounted?',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final sheet = find.byType(BottomSheet);
    expect(sheet, findsOneWidget);
    expect(
      find.descendant(of: sheet, matching: find.text('Change result')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: sheet,
        matching: find.text(
          'Is the rear registration plate clearly visible and correctly mounted?',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: sheet,
        matching: find.text(
          'Are both head lamps working on high and low beam?',
        ),
      ),
      findsNothing,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('PASS')),
      findsOneWidget,
    );
    // Nothing changed yet: the action says so and is disabled.
    expect(
      find.descendant(of: sheet, matching: find.text('No changes to update')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('Current')),
      findsOneWidget, // under FAIL, the question's current result
    );
    expect(
      find.descendant(of: sheet, matching: find.text('Cancel')),
      findsOneWidget,
    );
  });

  testWidgets('choosing a new result names the action; Cancel closes', (
    tester,
  ) async {
    await pumpScreen(tester, width: 360);
    await tester.tap(
      find.text(
        'Is the rear registration plate clearly visible and correctly mounted?',
      ),
    );
    await tester.pumpAndSettle();
    final sheet = find.byType(BottomSheet);

    await tester.tap(find.descendant(of: sheet, matching: find.text('PASS')));
    await tester.pump();
    expect(
      find.descendant(of: sheet, matching: find.text('Update to PASS')),
      findsOneWidget,
    );

    await tester.tap(find.descendant(of: sheet, matching: find.text('Cancel')));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('close button dismisses the sheet', (tester) async {
    await pumpScreen(tester, width: 360);
    await tester.tap(find.text('Are both head lamps working on high and low beam?'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
  });

  for (final width in [320.0, 412.0]) {
    testWidgets('change sheet fits at ${width}dp, text x1.3', (tester) async {
      await pumpScreen(tester, width: width, textScale: 1.3);
      await tester.tap(find.text('Is the windscreen free of cracks?'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // Pending question: the current result reads PENDING in the sheet too.
      expect(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text('PENDING'),
        ),
        findsOneWidget,
      );
      expect(find.text('Select a result'), findsOneWidget);
    });
  }
}

/// Overall verdict for other result mixes.
void verdictTests() {
  Future<void> pumpWith(WidgetTester tester, List<ResultData> data) async {
    final p = AiResultProvider(
      aiResultUseCases: AiResultUseCases(resultRepository: NoResultRepo()),
    );
    p.aiResultEntity = AiResultEntity(success: true, data: data);
    tester.view.physicalSize = const Size(360, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: p),
          ChangeNotifierProvider(
            create: (_) => AiUpdateResultProvider(
              resultUseCases: AiUpdateResultUseCases(
                aiUpdateResultRepository: NoUpdateRepo(),
              ),
            ),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const AiResultScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  ResultData q(int id, String? result) => ResultData(
    id: id,
    labelId: id,
    documentId: 1,
    questionText: 'Question $id?',
    aiResponse: result == null ? null : AiResponse(overallResult: result),
  );

  testWidgets('all passed → PASS', (tester) async {
    await pumpWith(tester, [q(1, 'Pass'), q(2, 'pass')]);
    expect(find.text('All 2 checks passed'), findsOneWidget);
    expect(find.text('PASS'), findsNWidgets(3)); // verdict + 2 cards
  });

  testWidgets('no failure but still analysing → PENDING', (tester) async {
    await pumpWith(tester, [q(1, 'Pass'), q(2, 'Pending')]);
    expect(
      find.text('1 of 2 awaiting the AI · pull down to refresh'),
      findsOneWidget,
    );
    expect(find.text('PENDING'), findsNWidgets(2)); // verdict + card
  });

  testWidgets('no AI results → AI RESULT NOT AVAILABLE', (tester) async {
    await pumpWith(tester, [q(1, null), q(2, '')]);
    expect(find.text('AI RESULT NOT AVAILABLE'), findsOneWidget);
    expect(find.text('2 of 2 checks have no AI result'), findsOneWidget);
    expect(
      find.text('AI result not available').hitTestable(),
      findsNWidgets(2),
    );
  });

  testWidgets('empty response → "AI result not available" state', (
    tester,
  ) async {
    await pumpWith(tester, []);
    expect(find.text('AI result not available'), findsOneWidget);
    expect(find.text('Check again'), findsOneWidget);
  });
}
