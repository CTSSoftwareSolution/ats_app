import 'package:ats_app/Domain/repositories/login_repository.dart';
import 'package:ats_app/Domain/usecases/login_usecases.dart';
import 'package:ats_app/Presentation/provider/bottom_navigation_provider.dart';
import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/custom_bottom_navigation.dart';
import 'package:ats_app/Presentation/screens/login_page/login_screen.dart';
import 'package:ats_app/Presentation/screens/manual_inspection_images/manual_inspection_image_screen.dart';
import 'package:ats_app/Presentation/screens/profile_page/profile_screen.dart';
import 'package:ats_app/Presentation/screens/splash_page/splash_screen_responsive.dart';
import 'package:ats_app/app_config/ip_address_bottom_sheet_screen.dart';
import 'package:ats_app/image_processing/MediaPicker/file_provider.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Layout checks for the remaining core screens (Splash, Login, bottom
/// navigation, Profile, IP config sheet, Gather Vehicle Data): no overflow on
/// small phones, tablets or with enlarged text.

class NoLogin implements LoginRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Widget wrap(
  Widget child, {
  required double width,
  double textScale = 1.0,
  double height = 900,
}) => MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => LoginProvider(
        loginUseCases: LoginUseCases(loginRepository: NoLogin()),
      ),
    ),
    ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
    ChangeNotifierProvider(create: (_) => FileProvider()),
  ],
  child: MaterialApp(
    theme: AppTheme.light,
    home: MediaQuery(
      data: MediaQueryData(
        size: Size(width, height),
        textScaler: TextScaler.linear(textScale),
      ),
      child: child,
    ),
  ),
);

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      Preferences.name: 'Venkatanarasimharajuvaripeta Subramanyam',
      Preferences.email:
          'venkatanarasimharajuvaripeta.subramanyam@cerisetechsolutions.com',
      Preferences.location:
          'Regional Transport Office Automated Testing Station, Pune',
    });
    await Preferences.setPreferences();
    PackageInfo.setMockInitialValues(
      appName: 'ATS',
      packageName: 'ats',
      version: '1.0.13',
      buildNumber: '13',
      buildSignature: '',
    );
  });

  final screens = <String, Widget Function()>{
    'splash': () =>
        const Scaffold(body: SafeArea(child: SplashScreenResponsiveLayout())),
    'login': () => const LoginScreen(),
    'bottom navigation': () =>
        const Scaffold(bottomNavigationBar: CustomBottomNavigation()),
    'profile': () => const ProfileScreen(),
    'ip config sheet': () => const Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: IpAddressBottomSheetScreen(),
      ),
    ),
    'gather vehicle data': () => const ManualInspectionImageScreen(),
  };

  for (final entry in screens.entries) {
    for (final width in [320.0, 360.0, 412.0, 600.0]) {
      for (final scale in [1.0, 1.3]) {
        testWidgets('${entry.key} fits at ${width}dp, text x$scale', (
          tester,
        ) async {
          tester.view.physicalSize = Size(width, 900);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            wrap(entry.value(), width: width, textScale: scale),
          );
          await tester.pump(const Duration(milliseconds: 300));
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
