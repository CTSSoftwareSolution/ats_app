import 'package:ats_app/Data/model/request_model/reset_password_req_model.dart';
import 'package:ats_app/Data/model/request_model/send_otp_req_model.dart';
import 'package:ats_app/Data/model/request_model/verify_otp_req_model.dart';
import 'package:ats_app/Data/model/response_model/send_otp_res_model.dart';
import 'package:ats_app/Data/repositories_impl/login_repo_impl.dart';
import 'package:ats_app/Domain/entities/reset_password_entity.dart';
import 'package:ats_app/Domain/entities/send_otp_entity.dart';
import 'package:ats_app/Domain/entities/verify_otp_entity.dart';
import 'package:ats_app/Domain/repositories/reset_password_repository.dart';
import 'package:ats_app/Domain/repositories/send_otp_repository.dart';
import 'package:ats_app/Domain/repositories/verify_otp_repository.dart';
import 'package:ats_app/Domain/usecases/login_usecases.dart';
import 'package:ats_app/Domain/usecases/reset_password_usecases.dart';
import 'package:ats_app/Domain/usecases/send_otp_usecases.dart';
import 'package:ats_app/Domain/usecases/verify_otp_usecases.dart';
import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:ats_app/Presentation/provider/reset_password_provider.dart';
import 'package:ats_app/Presentation/provider/send_otp_provider.dart';
import 'package:ats_app/Presentation/provider/verify_otp_provider.dart';
import 'package:ats_app/Presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:ats_app/Presentation/screens/forgot_password/set_new_password_screen.dart';
import 'package:ats_app/Presentation/screens/forgot_password/verify_otp_screen.dart';
import 'package:ats_app/Presentation/screens/login_page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Test doubles for the domain repositories – the screens and providers run
// unchanged on top of them.
class FakeSendOtpRepo implements SendOtpRepository {
  final List<String?> emails = [];
  bool succeed = true;

  @override
  Future<SendOtpEntity> sendOtpApi(SendOtpReqModel requestModel) async {
    emails.add(requestModel.email);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return succeed
        ? SendOtpEntity(success: true, message: "OTP has been sent in your registered Email.", data: sendOtpData(validForMinutes: 2))
        : SendOtpEntity(success: false, message: "Email service unavailable");
  }
}

class FakeVerifyOtpRepo implements VerifyOtpRepository {
  final List<VerifyOtpReqModel> calls = [];

  @override
  Future<VerifyOtpEntity> verifyOtpApi(VerifyOtpReqModel requestModel) async {
    calls.add(requestModel);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return requestModel.otp == "123456"
        ? VerifyOtpEntity(success: true, message: "OTP verified")
        : VerifyOtpEntity(success: false, message: "Invalid or expired OTP");
  }
}

class FakeResetPasswordRepo implements ResetPasswordRepository {
  final List<ResetPasswordReqModel> calls = [];

  @override
  Future<ResetPasswordEntity> resetPasswordApi(ResetPasswordReqModel requestModel) async {
    calls.add(requestModel);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return ResetPasswordEntity(success: true, message: "Password changed");
  }
}

void main() {
  late FakeSendOtpRepo sendRepo;
  late FakeVerifyOtpRepo verifyRepo;
  late FakeResetPasswordRepo resetRepo;
  late SendOtpProvider sendOtpProvider;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('PonnamKarthik/fluttertoast'),
      (call) async => true,
    );
    sendRepo = FakeSendOtpRepo();
    verifyRepo = FakeVerifyOtpRepo();
    resetRepo = FakeResetPasswordRepo();
  });

  Widget app(Widget home) {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1080, 2340);
    view.devicePixelRatio = 3.0;
    addTearDown(view.reset);
    sendOtpProvider = SendOtpProvider(sendOtpUseCases: SendOtpUseCases(sendOtpRepository: sendRepo));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider(loginUseCases: LoginUseCases(loginRepository: LoginRepoImpl()))),
        ChangeNotifierProvider.value(value: sendOtpProvider),
        ChangeNotifierProvider(create: (context) => VerifyOtpProvider(verifyOtpUseCases: VerifyOtpUseCases(verifyOtpRepository: verifyRepo), sendOtpProvider: context.read<SendOtpProvider>())),
        ChangeNotifierProvider(create: (context) => ResetPasswordProvider(resetPasswordUseCases: ResetPasswordUseCases(resetPasswordRepository: resetRepo), sendOtpProvider: context.read<SendOtpProvider>(), verifyOtpProvider: context.read<VerifyOtpProvider>())),
      ],
      child: MaterialApp(home: home, builder: EasyLoading.init()),
    );
  }

  Future<void> tapButton(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
  }

  Future<void> finish(WidgetTester tester) async {
    // Let the resend countdown run out so no timers are left pending.
    await tester.pump(const Duration(seconds: SendOtpProvider.resendCooldownSeconds + 1));
  }

  testWidgets('send OTP validates email and shows API error', (tester) async {
    sendRepo.succeed = false;
    await tester.pumpWidget(app(const ForgotPasswordScreen()));

    await tapButton(tester, find.text("Send OTP"));
    await tester.pumpAndSettle();
    expect(find.text("This field is required !"), findsOneWidget);
    expect(sendRepo.emails, isEmpty);

    await tester.enterText(find.byType(TextFormField), "user@example.com");
    await tapButton(tester, find.text("Send OTP"));
    await tester.pump();
    // Second tap while the request is in flight must not call the API again.
    await tester.tap(find.text("Send OTP"), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(sendRepo.emails, ["user@example.com"]);
    expect(find.text("Email service unavailable"), findsOneWidget);
    expect(find.byType(VerifyOtpScreen), findsNothing);
  });

  testWidgets('full flow: login -> send OTP -> verify OTP -> reset -> login', (tester) async {
    await tester.pumpWidget(app(const LoginScreen()));
    await tapButton(tester, find.text("Forgot password?"));
    await tester.pumpAndSettle();
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), "User@Example.com");
    await tapButton(tester, find.text("Send OTP"));
    await tester.pumpAndSettle();
    expect(sendRepo.emails, ["user@example.com"]);
    expect(find.byType(VerifyOtpScreen), findsOneWidget);
    expect(find.text("Enter the 6-digit code sent to user@example.com"), findsOneWidget);
    expect(find.text("OTP has been sent in your registered Email."), findsOneWidget);

    // Invalid length is caught locally.
    await tester.enterText(find.byType(TextFormField), "123");
    await tapButton(tester, find.text("Verify OTP").last);
    await tester.pumpAndSettle();
    expect(find.text("OTP must be exactly 6 digits"), findsOneWidget);
    expect(verifyRepo.calls, isEmpty);

    // Wrong OTP shows the API message and stays on the screen.
    await tester.enterText(find.byType(TextFormField), "000000");
    await tapButton(tester, find.text("Verify OTP").last);
    await tester.pumpAndSettle();
    expect(find.text("Invalid or expired OTP"), findsOneWidget);
    expect(find.byType(SetNewPasswordScreen), findsNothing);

    await tester.enterText(find.byType(TextFormField), "123456");
    await tapButton(tester, find.text("Verify OTP").last);
    await tester.pumpAndSettle();
    expect(verifyRepo.calls.last.email, "user@example.com");
    expect(find.byType(SetNewPasswordScreen), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), "weak");
    await tester.enterText(fields.at(1), "other");
    await tapButton(tester, find.text("Reset Password"));
    await tester.pumpAndSettle();
    expect(find.text("Password must have 8+ chars, include upper, lower, number & special char"), findsOneWidget);
    expect(find.text("Confirm password must be match with new password"), findsOneWidget);
    expect(resetRepo.calls, isEmpty);

    await tester.enterText(fields.at(0), "NewPass@123");
    await tester.enterText(fields.at(1), "NewPass@123");
    await tapButton(tester, find.text("Reset Password"));
    await tester.pumpAndSettle();

    expect(resetRepo.calls, hasLength(1));
    expect(resetRepo.calls.single.email, "user@example.com");
    expect(resetRepo.calls.single.otp, "123456");
    expect(resetRepo.calls.single.newPassword, "NewPass@123");
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(SetNewPasswordScreen), findsNothing);

    await finish(tester);
  });

  testWidgets('resend OTP is disabled during cooldown then calls the API', (tester) async {
    await tester.pumpWidget(app(const ForgotPasswordScreen()));
    await tester.enterText(find.byType(TextFormField), "user@example.com");
    await tapButton(tester, find.text("Send OTP"));
    await tester.pumpAndSettle();

    expect(find.textContaining("Resend in 00:"), findsOneWidget);
    await tester.tap(find.textContaining("Resend in"));
    await tester.pump();
    expect(sendRepo.emails, hasLength(1));

    await finish(tester);
    expect(find.text("Resend OTP"), findsOneWidget);
    await tapButton(tester, find.text("Resend OTP"));
    await tester.pumpAndSettle();
    expect(sendRepo.emails, hasLength(2));

    await finish(tester);
  });
}
