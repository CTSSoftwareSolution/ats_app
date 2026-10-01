
import 'package:ats_app/Presentation/screens/login_page/terms_conditions_screen.dart';
import 'package:ats_app/utilities/app_theme.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen_responsive.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: const AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.statusBarStyle,
        child: Scaffold(
          backgroundColor: appColor,
          bottomNavigationBar: TermsConditionsScreen(),
          body: SafeArea(
            child: LoginResponsiveLayout(),
          ),
        ),
      ),
    );
  }
}
