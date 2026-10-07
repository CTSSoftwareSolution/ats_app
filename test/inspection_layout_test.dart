import 'package:ats_app/Data/model/response_model/inspection_new_que_model.dart';
import 'package:ats_app/Domain/entities/inspection_new_que_entity.dart';
import 'package:ats_app/Domain/repositories/ai_inspection_details_repository.dart';
import 'package:ats_app/Domain/repositories/inspection_new_que_repository.dart';
import 'package:ats_app/Domain/usecases/ai_inspection_details_usecases.dart';
import 'package:ats_app/Domain/usecases/inspection_new_que_usecases.dart';
import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/provider/inspection_form_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/section_tab_view.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Inspection section / category / question UI: fits small screens and large
/// text, shows results and severity, and the question filter works.

class FakeQuestions implements InspectionNewQueRepository {
  @override
  Future<InspectionNewQueEntity> newQuestionApi() async {
    CarData q(int id, String text) => CarData(
      questionId: id,
      questionText: text,
      items: [Items(itemId: id, itemText: text)],
    );
    return InspectionNewQueEntity(
      status: true,
      data: NewInspectionData(
        preInspection: [
          PreInspection(
            title: 'Lighting and signalling devices (front and rear)',
            carData: [
              q(
                1,
                'Are both head lamps working on high and low beam, correctly aimed and free of cracks or moisture?',
              ),
              q(2, 'Are the indicators working?'),
              q(3, 'Is the number plate lamp working?'),
            ],
          ),
          PreInspection(
            title: 'Body',
            carData: [q(4, 'Is the body free of sharp edges?')],
          ),
        ],
        underPitInspection: [
          UnderPitInspection(
            title: 'Steering',
            carData: [q(5, 'Is steering play within limits?')],
          ),
        ],
        postInspection: [
          PostInspection(
            title: 'Brakes',
            carData: [q(6, 'Do the brakes meet the test?')],
          ),
        ],
      ),
    );
  }
}

class NoDetails implements AIInspectionDetailsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<InspectionFormProvider> _loadedProvider() async {
  final p = InspectionFormProvider(
    inspectionNewQueUseCases: InspectionNewQueUseCases(
      inspectionNewQueRepository: FakeQuestions(),
    ),
  );
  await p.fetchInspectionData();
  // Pre-Inspection is section 0 in the visible (visual) list and in _sections.
  p.answerQuestion(
    sectionIndex: 0,
    categoryIndex: 0,
    questionIndex: 0,
    answer: AnswerState.Pass,
  );
  p.answerQuestion(
    sectionIndex: 0,
    categoryIndex: 0,
    questionIndex: 1,
    answer: AnswerState.Fail,
  );
  return p;
}

Future<void> _pump(
  WidgetTester tester,
  InspectionFormProvider form, {
  required double width,
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = Size(width, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: form),
        ChangeNotifierProvider(
          create: (_) => AiInspectionDetailsProvider(
            aiInspectionDetailsUseCases: AIInspectionDetailsUseCases(
              detailsRepository: NoDetails(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(width, 2600),
            textScaler: TextScaler.linear(textScale),
          ),
          child: const Scaffold(body: SectionTabView(sectionIndex: 0)),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final width in [320.0, 360.0, 412.0, 600.0]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('inspection section fits at ${width}dp, text x$scale', (
        tester,
      ) async {
        final form = await tester.runAsync(_loadedProvider);
        await _pump(tester, form!, width: width, textScale: scale);
        expect(tester.takeException(), isNull);
        expect(find.text('Pre-Inspection'), findsOneWidget);
        expect(find.text('High severity'), findsOneWidget);
        // The first question of each category shows its number (or its
        // result once answered) in the marker.
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is Semantics &&
                (w.properties.label ?? '').startsWith('Question 1,'),
          ),
          findsNWidgets(2),
        );
        // Answers say what they mean.
        expect(find.text('Yes · Pass'), findsWidgets);
        expect(find.text('No · Fail'), findsWidgets);
      });
    }
  }

  _questionUiTests();
  _underPitTests();

  testWidgets('"No" filter shows only failed questions', (tester) async {
    final form = await tester.runAsync(_loadedProvider);
    await _pump(tester, form!, width: 360);
    expect(find.text('Is the number plate lamp working?'), findsOneWidget);

    form.setFilter(QuestionFilter.no);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Are the indicators working?'), findsOneWidget);
    expect(find.text('Is the number plate lamp working?'), findsNothing);
    expect(find.text('Body'), findsNothing); // category with no failures hidden
  });

  testWidgets('filter with no matches shows an explanatory empty state', (
    tester,
  ) async {
    final form = await tester.runAsync(_loadedProvider);
    form!.setFilter(QuestionFilter.answered);
    form.answerQuestion(
      sectionIndex: 0,
      categoryIndex: 0,
      questionIndex: 0,
      answer: AnswerState.Pass,
    ); // toggles off
    form.answerQuestion(
      sectionIndex: 0,
      categoryIndex: 0,
      questionIndex: 1,
      answer: AnswerState.Fail,
    ); // toggles off
    await _pump(tester, form, width: 360);
    expect(find.text('Nothing answered yet'), findsOneWidget);
  });
}

/// Labels of every question marker (number, or result once answered).
List<String> _markerLabels(WidgetTester tester) => tester
    .widgetList<Semantics>(
      find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            (w.properties.label ?? '').startsWith('Question '),
      ),
    )
    .map((s) => s.properties.label!)
    .toList();

void _questionUiTests() {
  testWidgets('markers show passed / failed / not answered', (tester) async {
    final form = await tester.runAsync(_loadedProvider);
    await _pump(tester, form!, width: 360);
    final labels = _markerLabels(tester);
    expect(labels, contains('Question 1, passed'));
    expect(labels, contains('Question 2, failed'));
    expect(labels, contains('Question 3, not answered'));
    // The failed question groups its details in one panel.
    expect(find.text('Defect details').hitTestable(), findsOneWidget);
    expect(find.text('Add evidence photo').hitTestable(), findsOneWidget);
  });

  testWidgets('tapping "Yes · Pass" records Pass through the provider', (
    tester,
  ) async {
    final form = await tester.runAsync(_loadedProvider);
    await _pump(tester, form!, width: 360);
    // Third question of the first category is still open.
    await tester.tap(find.text('Yes · Pass').at(2));
    await tester.pump(const Duration(milliseconds: 600));
    expect(
      form.sections[0].categories[0].questions[2].answer,
      AnswerState.Pass,
    );
    expect(_markerLabels(tester), contains('Question 3, passed'));
  });
}

/// Under-PIT is the same screen in another provider mode: one section, no
/// tab strip, same question UI.
void _underPitTests() {
  Future<InspectionFormProvider> underPit() async {
    final p = await _loadedProvider();
    p.setInspectionMode(InspectionMode.underPitInspection);
    return p;
  }

  for (final width in [320.0, 412.0, 600.0]) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('Under-PIT section fits at ${width}dp, text x$scale', (
        tester,
      ) async {
        final form = await tester.runAsync(underPit);
        await _pump(tester, form!, width: width, textScale: scale);
        expect(tester.takeException(), isNull);
        expect(find.text('Under-PIT Inspection'), findsOneWidget);
        expect(find.text('Steering'), findsOneWidget);
        expect(_markerLabels(tester), ['Question 1, not answered']);
        expect(find.text('Yes · Pass'), findsOneWidget);
        expect(find.text('No · Fail'), findsOneWidget);
      });
    }
  }

  testWidgets('Under-PIT "No · Fail" records Fail and opens defect details', (
    tester,
  ) async {
    final form = await tester.runAsync(underPit);
    await _pump(tester, form!, width: 360);
    await tester.tap(find.text('No · Fail'));
    await tester.pumpAndSettle();
    expect(
      form.visibleSections.single.categories.single.questions.single.answer,
      AnswerState.Fail,
    );
    expect(_markerLabels(tester), ['Question 1, failed']);
    expect(find.text('Defect details').hitTestable(), findsOneWidget);
    expect(find.text('High severity'), findsOneWidget);
    expect(find.text('Add evidence photo').hitTestable(), findsOneWidget);
  });
}
