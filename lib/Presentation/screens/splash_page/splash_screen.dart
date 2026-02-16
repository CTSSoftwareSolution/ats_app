import 'package:ats_app/Presentation/provider/splash_provider.dart';
import 'package:ats_app/Presentation/screens/splash_page/splash_screen_responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xff345afa), Color(0xff19162e)
            ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: SplashScreenResponsiveLayout()
        ),
      ),
    );
  }
}
