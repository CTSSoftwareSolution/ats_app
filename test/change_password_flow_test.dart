import 'package:ats_app/Data/model/request_model/change_password_req_model.dart';
import 'package:ats_app/Domain/entities/change_password_entity.dart';
import 'package:ats_app/Domain/repositories/change_password_repository.dart';
import 'package:ats_app/Domain/usecases/change_password_usecases.dart';
import 'package:ats_app/Presentation/provider/change_password_provider.dart';
import 'package:ats_app/Presentation/screens/profile_page/change_password_screen.dart';
import 'package:ats_app/Presentation/screens/profile_page/profile_screen.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _userId = "3f2b8c1e-0000-4000-8000-000000000001";

// Test double for the domain repository – the screen and provider run
// unchanged on top of it.
class FakeChangePasswordRepo implements ChangePasswordRepository {
  final List<ChangePasswordReqModel> calls = [];

  @override
  Future<ChangePasswordEntity> changePasswordApi(ChangePasswordReqModel requestModel) async {
    calls.add(requestModel);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return requestModel.oldPassword == "OldPass@123"
        ? ChangePasswordEntity(success: true, message: "Password changed successfully")
        : ChangePasswordEntity(success: false, message: "Old password is incorrect");
  }
}

void main() {
  late FakeChangePasswordRepo repo;

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('PonnamKarthik/fluttertoast'),
      (call) async => true,
    );
    SharedPreferences.setMockInitialValues({
      Preferences.userId: _userId,
      Preferences.name: "Test User",
      Preferences.email: "test@example.com",
      Preferences.image: "",
    });
    await Preferences.setPreferences();
    repo = FakeChangePasswordRepo();
  });

  Widget app() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1080, 2340);
    view.devicePixelRatio = 3.0;
    addTearDown(view.reset);
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordProvider(
        changePasswordUseCases: ChangePasswordUseCases(changePasswordRepository: repo),
      ),
      child: MaterialApp(home: const ProfileScreen(), builder: EasyLoading.init()),
    );
  }

  Future<void> tapButton(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
  }

  Finder field(int index) => find.byType(TextFormField).at(index);

  testWidgets('profile -> change password: validation, API error, success returns to profile', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tapButton(tester, find.text("Change Password"));
    await tester.pumpAndSettle();
    expect(find.byType(ChangePasswordScreen), findsOneWidget);
    final submit = find.widgetWithText(FilledButton, "Change Password");

    // Empty form.
    await tapButton(tester, submit);
    await tester.pumpAndSettle();
    expect(find.text("Please Enter Current Password"), findsOneWidget);
    expect(find.text("Please Enter New Password"), findsOneWidget);
    expect(find.text("Please Enter Confirm Password"), findsOneWidget);

    // Same as current / weak / mismatch.
    await tester.enterText(field(0), "OldPass@123");
    await tester.enterText(field(1), "OldPass@123");
    await tester.enterText(field(2), "Different@1");
    await tapButton(tester, submit);
    await tester.pumpAndSettle();
    expect(find.text("New password must be different from current password"), findsOneWidget);
    expect(find.text("Confirm password must be match with new password"), findsOneWidget);

    await tester.enterText(field(1), "weak");
    await tapButton(tester, submit);
    await tester.pumpAndSettle();
    expect(find.text("Password must have 8+ chars, include upper, lower, number & special char"), findsOneWidget);
    expect(repo.calls, isEmpty);

    // Visibility toggle.
    EditableText editable(int i) => tester.widget<EditableText>(
        find.descendant(of: field(i), matching: find.byType(EditableText)));
    expect(editable(0).obscureText, isTrue);
    await tester.tap(find.byTooltip("Show password").first);
    await tester.pump();
    expect(editable(0).obscureText, isFalse);

    // Wrong current password: API message shown, stays on screen.
    await tester.enterText(field(0), "Wrong@123");
    await tester.enterText(field(1), "NewPass@123");
    await tester.enterText(field(2), "NewPass@123");
    await tapButton(tester, submit);
    await tester.pump();
    // Second tap while in flight must not trigger another call.
    await tester.tap(submit, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(repo.calls, hasLength(1));
    expect(find.text("Old password is incorrect"), findsOneWidget);
    expect(find.byType(ChangePasswordScreen), findsOneWidget);

    // Success: correct request, back on Profile.
    await tester.enterText(field(0), "OldPass@123");
    await tapButton(tester, submit);
    await tester.pumpAndSettle();
    expect(repo.calls, hasLength(2));
    expect(repo.calls.last.userId, _userId);
    expect(repo.calls.last.oldPassword, "OldPass@123");
    expect(repo.calls.last.newPassword, "NewPass@123");
    expect(find.byType(ChangePasswordScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsOneWidget);

    // Re-opening starts with a clean form.
    await tapButton(tester, find.text("Change Password"));
    await tester.pumpAndSettle();
    expect(tester.widget<TextFormField>(field(0)).controller!.text, isEmpty);
    expect(find.text("Old password is incorrect"), findsNothing);

    // Let the success toast's timer expire.
    await tester.pump(const Duration(seconds: 3));
  });
}
