
import 'package:ats_app/Presentation/screens/login_page/terms_conditions_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen_responsive.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff345afa), Color(0xff19162e)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: TermsConditionsScreen(),
        body: SafeArea(
          child: LoginResponsiveLayout(),
        ),
      ),
    );
  }
}
