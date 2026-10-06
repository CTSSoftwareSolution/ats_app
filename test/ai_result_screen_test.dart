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
      ),
      ResultData(
        id: 3,
        labelId: 13,
        documentId: 1,
        questionText: 'Is the windscreen free of cracks?',
        aiResponse: AiResponse(overallResult: 'Pending'),
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
        expect(find.text('INSPECTION QUESTION 2 OF 3'), findsOneWidget);
        expect(find.text('Change result'), findsNWidgets(3));
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
    ]);
    expect(find.text('Overall Result'), findsWidgets);
    expect(find.text('Headlights detected'), findsWidgets);
    expect(find.text('Number of headlights'), findsWidgets);
    expect(find.text('Processing time sec'), findsNothing);
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

    expect(find.text('Change Result'), findsOneWidget);
    final sheet = find.ancestor(
      of: find.text('Change Result'),
      matching: find.byType(BottomSheet),
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
    expect(
      find.descendant(of: sheet, matching: find.text('Update')),
      findsOneWidget,
    );
  });
}
