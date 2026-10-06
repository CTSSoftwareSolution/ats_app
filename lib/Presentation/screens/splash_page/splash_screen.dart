import 'package:ats_app/Presentation/provider/splash_provider.dart';
import 'package:ats_app/Presentation/screens/splash_page/splash_screen_responsive.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../utilities/new_app_theme/app_theme.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    context.read<SplashProvider>().startTimer(context);
  }


  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.statusBarStyle,
      child: Scaffold(
        backgroundColor: appColor,
        body: SafeArea(
          child: SplashScreenResponsiveLayout(),
        ),
      ),
    );
  }
}
