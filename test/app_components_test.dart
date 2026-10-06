import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:ats_app/widgets/new_app_ui/app_bottom_sheet.dart';
import 'package:ats_app/widgets/new_app_ui/app_top_bar.dart';
import 'package:ats_app/widgets/new_app_ui/list_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared components: app bar variants, list footer states and the
/// standard bottom sheet helper.
void main() {
  Widget app(Widget home) => MaterialApp(theme: AppTheme.light, home: home);

  testWidgets('AppTopBar: tab root has no back button, pushed screen does', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(const Scaffold(appBar: AppTopBar(title: 'Result'))),
    );
    expect(find.byTooltip('Back'), findsNothing);

    var popped = false;
    await tester.pumpWidget(
      app(
        Scaffold(
          appBar: AppTopBar(
            title:
                'Vehicle Test Parameter with a very long title that must ellipsize',
            subtitle: 'MH12AB1234',
            onBack: () => popped = true,
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('MH12AB1234'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    expect(popped, isTrue);
  });

  testWidgets('ListFooter shows loading, end and nothing-yet states', (
    tester,
  ) async {
    Future<void> pumpFooter(ListFooter f) =>
        tester.pumpWidget(app(Scaffold(body: Center(child: f))));

    await pumpFooter(
      const ListFooter(
        isLoadingMore: true,
        reachedEnd: false,
        count: 20,
        singular: 'result',
        plural: 'results',
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await pumpFooter(
      const ListFooter(
        isLoadingMore: false,
        reachedEnd: true,
        count: 20,
        singular: 'result',
        plural: 'results',
      ),
    );
    expect(find.text('All 20 results shown'), findsOneWidget);

    await pumpFooter(
      const ListFooter(
        isLoadingMore: false,
        reachedEnd: false,
        count: 20,
        singular: 'result',
        plural: 'results',
      ),
    );
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('showAppBottomSheet opens a scrollable AppBottomSheet', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showAppBottomSheet(
                context: context,
                builder: (_) =>
                    const AppBottomSheet(title: 'Uploads', child: Text('body')),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Uploads'), findsOneWidget);
    expect(find.text('body'), findsOneWidget);
  });
}
